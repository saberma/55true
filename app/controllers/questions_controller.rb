class QuestionsController < ApplicationController  
  layout 'facebox'
  before_filter :check_xhr, :only => :show
  before_filter :check_login, :only => [:new,:create]
  before_filter :check_xhr, :check_admin, :only => :destroy
  caches_action :index, :expires_in => 5.minutes, :if => Proc.new{|c| c.params[:page].blank? || c.params[:page]=='1' }

  #顶得最多
  def index
    @page = Answer.populate.with_question.paginate(:page => params[:page])
    render :layout => "application"
  end

  def create
    @question = current_user.questions.create(params[:question])
    if @question.errors.empty?
      flash[:notice] = "接题成功!"
    else
      render :action => :create_error
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
  end

  def show
    question = Question.find(params[:id], :include => :answer)
    @answer = question.answer
    redirect_to home_path and return unless @answer
    render :layout => "application"
  end

  #顶
  def update
    if logged_in? && (current_user.score >= POPULATE_SCORE)
      question = Question.find(params[:id])
      question.increment! :populate
      #减积分
      current_user.decrement! :score, POPULATE_SCORE
    end
    render :nothing => true
  end
end
