module Receive
  extend UsersHelper

  @queue = "receive"
  
  def self.perform(id)
    qa = Qa.find(id)
    user_id = get_online_user_id_except(qa.user.id.to_s)
    user = User.find(user_id)

    av = ActionView::Base.new(Rails.configuration.view_path)
    content = av.render(:partial => "home/answering", :locals => {:a_user => user.name, :user => qa.user.name, :content => qa.content})
    Juggernaut.publish "chat", :system => content
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
