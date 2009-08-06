class HomeController < ApplicationController
  def index
    #今天谁在玩
    @today_users_size = memcache('today_users_size') { User.today.size }
    @today_users = memcache('today_users') { User.today_top }
    @users_size = memcache('users_size') { User.all.size }
    #用户问的
    if logged_in?
      @user_unanswer_question_list = Question.unanswer.of current_user
      @user_answered_question_list = Question.limit(2).answered.of(current_user)
      @answer_list = Answer.with_question.paginate(:page => params[:page])
      flash.now[:notice] = "这里的#{@users_size}个朋友(共玩了#{@answer_list.total_entries}次)，点击下一行“我敢玩”继续吧!" unless flash[:notice]
      #用户收到的消息
      @message = Message.to(current_user).first
    else
      @answer_list = Answer.with_question.paginate(:page => params[:page])
      flash.now[:notice] = "这里的#{@users_size}个朋友(共玩了#{@answer_list.total_entries}次)，想跟你一起玩真心话，点击下一行“我敢玩”就可以开始了!"
    end
  end

end
