class CreateUnansweredQuestions < ActiveRecord::Migration
  def self.up
    create_table :unanswered_questions do |t|
      t.references :question, :null => false
      t.references :user, :null => false
      t.references :player, :null => false
      t.datetime :play_time, :null => false
    end
  end

  def self.down
    drop_table :unanswered_questions
  end
end
