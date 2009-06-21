class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  layout 'facebox', :except => :panel
  before_filter :check_xhr, :check_admin, :only => :destroy

  def new
    if is_forbid_register?
      flash.now[:notice] = "暂停注册，重新开放时间:#{session[:o]}"
      render :action => "forbid"
    end
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      flash[:notice] = "注册成功!"
      #pop the answer facebox
      flash[:play] = true unless is_admin?
    else
      render :action => 'create_error'
    end
  end

  def update
    User.find(params[:id]).update_attribute(:photo, params[:user][:photo]) if params[:user]
    redirect_to home_path
  end

  def show
    @user = User.find(params[:id])
    unless @user
      flash[:error] = "用户不存在!"
      redirect_to home_url and return
    end
    @title = "#{@user.login} | 真心话网"
    @his_answered_question_list = Question.limit(10).answered.of(@user)
    @his_answer_list = Answer.with_question.limit(10).of(@user)
    render :layout => "application"
  end

  def panel
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).update_attribute(:score, -PUNISH_SCORE)
  end
end
