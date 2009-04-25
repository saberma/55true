class HomeController < ApplicationController
  def index
    
    #用户问的
    if logged_in?
      @user_unanswer_question_list = Question.unanswer.of current_user
      @user_answered_question_list = Question.limit(3).answered.of(current_user)
      @question_list = Question.answered.not_belong_to(current_user).paginate(:page => params[:page])
    else
      @question_list = Question.answered.paginate(:page => params[:page])
      flash.now[:notice] = "让你玩真心话游戏更方便，点击下一行“我敢玩”就可以开始了!"
    end
  end

end
