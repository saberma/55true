class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, :class_name => 'User'

  validates_presence_of     :content
  validates_length_of       :content, :maximum => 120

  PUNISH_CONTENT = <<-EOF
抱歉，您于<%= time %>所提问题不符合网站规则,已屏蔽，扣除积分<%= PUNISH_SCORE %>，问题内容为:<%= content %>
  EOF

  ADD_FRIEND_CONTENT = "(系统消息，无须回复)<%=current_user.login%>刚加你为好友了!"

  named_scope :to, lambda {|user|
    {:conditions => ["is_readed = ? and user_id = ?", false, user.id], :limit => 1, :order => "updated_at asc"}
  }

  named_scope :with, lambda {|from, to|
    {:conditions => ["creator_id = ? and user_id = ?", from.id, to.id], :limit => 1, :order => "updated_at desc"}
  }

  after_create do |message|
    creator = message.creator
    creator.decrement!(:score, SEND_MSG_SCORE) unless creator == User.admin
  end
  
end
