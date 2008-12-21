class QuestionsController < ApplicationController  
  def create
    @question = current_user.questions.create(params[:question])
    if @question.errors.empty?
      flash[:notice] = "接题成功!"
      redirect_to :controller => :home
    else
      render :action => 'new'
    end
  end
end
