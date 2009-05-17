class QuestionsController < ApplicationController  
  layout 'facebox'
  before_filter :check_xhr, :only => :show
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
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
  end
end
