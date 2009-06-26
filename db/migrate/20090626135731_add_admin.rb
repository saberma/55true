class AddAdmin < ActiveRecord::Migration
  def self.up
    u = User.find_by_login('saberma')
    if u
      u.update_attribute(:login,'55true管理员')
    else
      User.create!({
        :login => '55true管理员',
        :password => 'admin',
        :score => 1000
      })
    end
  end

  def self.down
    User.find_by_login('55true管理员').update_attribute(:login, 'saberma')
  end
end
