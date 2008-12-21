class HomeController < ApplicationController
  def index
    
    #用户问的
    if logged_in?
      @user_unanswer_question_list = Question.unanswer.of current_user
      @user_answered_question_list = Question.limit(3).answered.of(current_user)
      @question_list = Question.answered.not_belong_to current_user
    else
      @question_list = Question.answered
    end
  end

end
