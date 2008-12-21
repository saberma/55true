class CreatePageViews < ActiveRecord::Migration
  def self.up
    create_table :page_views do |t|
      t.integer :user_id
      t.string :request_url
      t.string :ip_address
      t.string :referer
      t.string :user_agent

      t.timestamps
    end
  end

  def self.down
    drop_table :page_views
  end
end
