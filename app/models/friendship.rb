class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"

  def self.added?(user_id, friend_id)
    (user_id == friend_id) || !self.find_by_user_id_and_friend_id(user_id, friend_id).nil?
  end
end
