class QuestionsController < ApplicationController  
  layout 'facebox'

  def create
    @question = current_user.questions.create(params[:question])
    if @question.errors.empty?
      flash[:notice] = "接题成功!"
    else
      render :action => :create_error
    end
  end

  def show
    question = Question.find(params[:id])
    @answered_question = question if question.is_answered
  end
end
