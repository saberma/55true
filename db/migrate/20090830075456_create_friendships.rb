class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.references :user, :null => false
      t.integer :friend_id, :null => false
      t.datetime :created_at
    end
    add_index :friendships, :user_id
  end

  def self.down
    drop_table :friendships
  end
end
