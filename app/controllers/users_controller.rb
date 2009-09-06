class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  layout 'facebox', :except => :panel
  before_filter :check_xhr, :check_admin, :only => :destroy
  before_filter :get_user, :only => [:show, :questions]
  #缓存用户面板
  caches_action :panel, :expires_in => 5.minutes

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
    @list = Answer.with_question.of(@user).paginate(:page => params[:page])
    render :action => "show", :layout => "application"
  end

  def questions
    @list = Answer.with_question.question_of(@user).paginate(:page => params[:page])
    render :action => "show", :layout => "application"
  end

  def panel
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).update_attribute(:score, -PUNISH_SCORE)
  end

  def get_user
    @user = User.find(params[:id])
    unless @user
      flash[:error] = "用户不存在!"
      redirect_to home_url and return
    end
    #好友
    @friends_list = @user.friends
    @title = "#{@user.login} | 真心话网"
  end
end
