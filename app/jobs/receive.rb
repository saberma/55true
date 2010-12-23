module Receive
  extend UsersHelper

  @queue = "receive"
  
  def self.perform(id)
    qa = Qa.find(id)
    user_id = get_online_user_id_except(qa.user.id.to_s)
    user = User.find(user_id)

    Juggernaut.publish "chat", :name => user.name, :time => Time.now.to_s(:short), :msg => I18n.t('message.answering', :user => qa.user.name, :content => qa.content)
    sleep 300
  end

  def self.get_online_user_id_except(qa_user_id)
    user_id = nil
    loop do
      onlines = online_user_ids
      user_id = onlines[rand(onlines.size)]
      break if !user_id.blank? and user_id != qa_user_id
      sleep 2
    end
    user_id
  end
end
