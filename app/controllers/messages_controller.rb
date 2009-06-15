class MessagesController < ApplicationController
  layout 'facebox'
  before_filter :check_login, :except => :new

  def new
    unless logged_in?
      flash.now[:notice] = "请先注册或登录，注册只需6秒."
      render :partial => '/shared/notice' and return 
    end
    if(current_user.score < SEND_MSG_SCORE)
      flash.now[:notice] = "发送消息需要#{SEND_MSG_SCORE}个积分,你的积分不足,暂时不能使用此功能."
      render :partial => '/shared/notice' and return 
    end
    @user = User.find(params[:user_id])
    @message = Message.new
  end

  def create
    if(current_user.score < SEND_MSG_SCORE)
      flash.now[:notice] = "发送消息需要#{SEND_MSG_SCORE}个积分,你的积分不足,暂时不能使用此功能."
      render :partial => '/shared/notice' and return 
    end
    @model = Message.new(params[:message])
    @model.creator = current_user
    @model.user_id = params[:user_id]
    if @model.save
      #已回复的信息置为已读
      unless params[:from_message_id].blank?
        message = current_user.messages.find(params[:from_message_id])
        message.update_attribute(:is_readed, true)
      end
      flash.now[:notice] = "发送成功!"
    else
      render :partial => '/shared/create_error'
    end
  end

  def update
    @message = current_user.messages.find(params[:id])
    @message.update_attribute(:is_readed, true)
  end
end
