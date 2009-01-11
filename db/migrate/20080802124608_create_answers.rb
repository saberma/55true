class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.string :content, :null => false
      t.references :question, :null => false
      t.references :user, :null => false

      t.timestamps
    end
    #foreign index
    add_index :answers, :user_id
    add_index :answers, :question_id, :unique => true
    #homepage list 
    add_index :answers, :updated_at
  end

  def self.down
    drop_table :answers
  end
end
