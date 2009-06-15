class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, :class_name => 'User'

  validates_presence_of     :content
  validates_length_of       :content, :maximum => 120

  named_scope :to, lambda {|user|
    {:conditions => ["is_readed = ? and user_id = ?", false, user.id], :limit => 1, :order => "updated_at asc"}
  }

  after_create do |message|
    message.creator.decrement!(:score, SEND_MSG_SCORE)
  end
  
end