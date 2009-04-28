class AddUnansweredQuestionSequence < ActiveRecord::Migration
  def self.up
    add_column :unanswered_questions, :sequence, :integer, :default => 0, :null => false, :limit => 4
  end

  def self.down
    remove_column :unanswered_questions, :sequence
  end
end
