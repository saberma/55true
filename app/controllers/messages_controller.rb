class MessagesController < ApplicationController
  layout 'facebox'
  before_filter :check_login, :except => :new
  before_filter :check_xhr, :only => :index
  include MessagesHelper

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
    @last_message = Message.with(current_user, @user).first
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
      add_relate(@model.user_id)
      flash.now[:notice] = "发送成功!花费积分#{SEND_MSG_SCORE}"
      #清除首页动态更新的消息缓存
      expire_memcache "messages_#{@model.user_id}"
      expire_memcache "messages_#{current_user.id}"
    else
      render :partial => '/shared/create_error'
    end
  end

  def update
    #清除首页动态更新的消息缓存,否则已读的消息会不断收到
    expire_memcache "messages_#{current_user.id}"
    @message = current_user.messages.find(params[:id])
    @message.update_attribute(:is_readed, true)
  end

  #用户收到的消息(缓存，有新消息则清空缓存)
  def index
    @message_list = memcache("messages_#{current_user.id}") {Message.to(current_user)}
  end
end
