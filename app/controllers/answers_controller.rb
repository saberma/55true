class AnswersController < ApplicationController
  layout 'facebox'
  before_filter :check_xhr, :only => :new
  before_filter :check_xhr, :check_admin, :only => :destroy

  #接题
  def new
    unless logged_in?
      flash[:notice] = "请先注册或登录，注册只需6秒."
      redirect_to(:controller => "users", :action => "new") and return
    end
    #检查积分
    if current_user.forbid?
      flash.now[:notice] = "抱歉，由于您未遵守本站规则，帐号已被禁用!<br/>无法接题!"
      render(:action => "wait") and return
    end
    unanswered_questions_size = current_user.unanswered_questions.size
    if unanswered_questions_size >= MAX_QUESTIONS
      flash.now[:notice] = "抱歉，您有#{unanswered_questions_size}个问题待答!<br/>暂时不能接题!"
      render(:action => "wait") and return
    end
    #先从session取问题，避免刷新选择问题
    @unanswer_question = UnansweredQuestion.same(current_user, session[:q]) if session[:q]
    @unanswer_question = UnansweredQuestion.for(current_user) unless @unanswer_question
    session[:q] = @unanswer_question.id if @unanswer_question
    redirect_to :controller => :questions, :action => :new unless @unanswer_question
  end
  
  #保存答案及新的问题
  def create
    @unanswer_question = Question.find_by_id(params[:previou_question])
    @answer = current_user.answers.new(params[:answer])
    @answer.question = @unanswer_question
    @question = current_user.questions.new(params[:question])

    unless [@answer, @question].map(&:valid?).include?(false)
      Answer.transaction do
        @answer.save!
        @question.save!
      end
    end

    if @answer.errors.empty? && @question.errors.empty?
      flash.now[:notice] = "接题成功!"
      #清除接题标记
      session[:q] = nil
    else
      unless @answer.errors.on_base.nil?
        flash[:error] = "超时了!"
      else
        render :action => :create_error
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
  end
end
