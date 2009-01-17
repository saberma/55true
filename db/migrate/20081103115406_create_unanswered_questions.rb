class CreateUnansweredQuestions < ActiveRecord::Migration
  def self.up
    create_table :unanswered_questions do |t|
      t.references :question, :null => false
      t.datetime :play_time, :null => false
      t.integer :checksum, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :unanswered_questions
  end
end
