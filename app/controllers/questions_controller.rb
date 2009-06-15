class QuestionsController < ApplicationController  
  layout 'facebox'
  before_filter :check_xhr, :only => :show
  before_filter :check_login, :only => [:new,:create]
  before_filter :check_xhr, :check_admin, :only => :destroy

  def create
    @question = current_user.questions.create(params[:question])
    if @question.errors.empty?
      flash[:notice] = "接题成功!"
    else
      render :action => :create_error
    end
  end

  def show
    @question_list = Question.newer(params[:id])
    if logged_in? && params[:message]
      #用户收到的消息
      @message = Message.to(current_user).first
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
  end
end
