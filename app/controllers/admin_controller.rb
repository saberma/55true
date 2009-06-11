class AdminController < ApplicationController
  before_filter :check_admin
  layout nil

  def index
    @unanswer_question_list = UnansweredQuestion.all.collect {|uq| uq.question}
    if params[:id]
      @user = User.find(params[:id])
      @question_list = Question.answered.of(@user).paginate(:page => params[:page], :per_page => 50)
    else
      @question_list = Question.answered.paginate(:page => params[:page], :per_page => 50)
    end
  end
end
