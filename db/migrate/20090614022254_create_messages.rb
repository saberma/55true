class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      #接收人
      t.references :user, :null => false
      #发送人
      t.integer :creator_id, :null => false
      t.string :content, :limit => 120, :null => false
      #已读标记
      t.boolean :is_readed, :null => false, :default => false

      t.timestamps
    end
    add_index :messages, [:is_readed, :user_id, :updated_at]
  end

  def self.down
    drop_table :messages
  end
end
