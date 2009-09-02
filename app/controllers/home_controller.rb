class HomeController < ApplicationController
  before_filter :to_member, :only => :index
  #只缓存首页第一页
  caches_action :index, :expires_in => 5.minutes, :if => Proc.new{|c| c.params[:page].blank? || c.params[:page]=='1' }

  def index
    init
    flash.now[:notice] = "这里的#{@users_size}个朋友(共玩了#{@answer_list.total_entries}次)，想跟你一起玩真心话，点击下一行“开始玩”就可以了!"
  end

  def member
    init
    #用户问的
    @user_unanswer_question_list = Question.unanswer.of(current_user)
    @user_answered_question_list = Question.limit(1).answered.of(current_user)
    flash.now[:notice] = "这里的#{@users_size}个朋友(共玩了#{@answer_list.total_entries}次)，点击下一行“开始玩”继续吧!" unless flash[:notice]

    #好友
    @friends_list = current_user.friends

    #用户收到的消息
    @message = Message.to(current_user).first
    render :action => "index"
  end

  private
  def to_member
    if logged_in?
      redirect_to home_member_path
    end
  end

  def init
    #今天谁在玩
    @today_users_size = memcache('today_users_size') { User.today.size }
    @today_users = memcache('today_users') { User.today_top }
    @users_size = memcache('users_size') { User.all.size }
    #缓存总数，避免count查询
    total_entries = memcache('total_entries') { Answer.with_question.size }

    #已登录会员页面的缓存不能太久，1分钟以内为佳
    @answer_list = memcache("member_page_#{params[:page]}", 1.minute) { Answer.with_question.paginate(:page => params[:page], :total_entries => total_entries) }
  end
end
