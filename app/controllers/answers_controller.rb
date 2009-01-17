class AnswersController < ApplicationController
  #接题
  def new
    if !logged_in?
      flash[:notice] = "请先注册或登录，注册只需6秒."
      redirect_to(:controller => "users", :action => "new") and return
    end
    @unanswer_question = UnansweredQuestion.for(current_user)
    redirect_to :controller => :questions, :action => :new unless @unanswer_question
  end
  
  #保存答案及新的问题
  def create
    @unanswer_question = Question.find_by_id(params[:previou_question])
    @answer = current_user.answers.new(params[:answer])
    @answer.question = @unanswer_question
    @answer.checksum = params[:checksum]
    @question = current_user.questions.new(params[:question])

    unless [@answer, @question].map(&:valid?).include?(false)
      Answer.transaction do
        @answer.save!
        @question.save!
      end
    end

    if @answer.errors.empty? && @question.errors.empty?
      flash[:notice] = "接题成功!"
      redirect_to :controller => :home
    else
      unless @answer.errors.on_base.nil?
        flash[:error] = "超时了!"
        redirect_to :controller => :home
      else
        render :action => 'new'
      end
    end

  end
end
