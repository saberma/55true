class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   :login, :remember_token, :crypted_password
      t.datetime :remember_token_expires_at
      t.datetime :last_login, :null => false
      t.integer :questions_count, :answers_count, :default => 0, :null => false
      #photo
      t.string :photo_file_name, :photo_content_type
      t.integer :photo_file_size
      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
