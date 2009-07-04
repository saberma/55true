module MessagesHelper
  #按先进先出，保存有消息来往的用户id
  def add_relate(user_id)
    session[:msg_relate] ||= []
    session[:msg_relate].delete(user_id)
    session[:msg_relate].push(user_id)
    session[:msg_relate].shift if session[:msg_relate].size>12
    session[:msg_relate]
  end
end
