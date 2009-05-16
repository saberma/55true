class AdminController < ApplicationController
  before_filter :check_admin
  layout nil

  def index
    @unanswer_question_list = UnansweredQuestion.all.collect {|uq| uq.question}
    @question_list = Question.answered.limit(50)
  end
end
