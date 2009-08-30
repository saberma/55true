# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090830075456) do

  create_table "answers", :force => true do |t|
    t.string   "content",     :default => "", :null => false
    t.integer  "question_id",                 :null => false
    t.integer  "user_id",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id", :unique => true
  add_index "answers", ["updated_at"], :name => "index_answers_on_updated_at"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "friend_id",  :null => false
    t.datetime "created_at"
  end

  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id",                                      :null => false
    t.integer  "creator_id",                                   :null => false
    t.string   "content",    :limit => 120, :default => "",    :null => false
    t.boolean  "is_readed",                 :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["is_readed", "user_id", "updated_at"], :name => "index_messages_on_is_readed_and_user_id_and_updated_at"

  create_table "page_views", :force => true do |t|
    t.integer  "user_id"
    t.string   "request_url"
    t.string   "ip_address"
    t.string   "referer"
    t.string   "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.string   "content",     :default => "",    :null => false
    t.boolean  "is_answered", :default => false, :null => false
    t.integer  "user_id",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["is_answered", "user_id"], :name => "index_questions_on_is_answered_and_user_id"

  create_table "unanswered_questions", :force => true do |t|
    t.integer  "question_id",                :null => false
    t.integer  "user_id",                    :null => false
    t.integer  "player_id",                  :null => false
    t.datetime "play_time",                  :null => false
    t.integer  "sequence",    :default => 0, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "remember_token"
    t.string   "crypted_password"
    t.datetime "remember_token_expires_at"
    t.datetime "last_login",                               :null => false
    t.integer  "questions_count",           :default => 0, :null => false
    t.integer  "answers_count",             :default => 0, :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score",                     :default => 0, :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
