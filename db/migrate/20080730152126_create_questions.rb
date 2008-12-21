class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :content, :null => false
      t.boolean :is_answered, :default => false, :null => false
      t.references :user, :null => false

      t.timestamps
    end
    add_index :questions, [:is_answered, :user_id]
  end

  def self.down
    drop_table :questions
  end
end
