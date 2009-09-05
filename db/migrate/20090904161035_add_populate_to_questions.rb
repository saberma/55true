class AddPopulateToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :populate, :integer, :default => 0, :null => false
    add_index :questions, :populate
  end

  def self.down
    remove_index :questions, :populate
    remove_column :questions, :populate
  end
end
