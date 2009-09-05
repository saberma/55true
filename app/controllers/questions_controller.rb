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

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
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
