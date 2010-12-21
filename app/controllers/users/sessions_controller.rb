# encoding: utf-8
# set online users
class Users::SessionsController < Devise::SessionsController
  before_filter :del_online, :only => :destroy
  after_filter :add_online, :only => :create

  protected
  def add_online
    Redis.new.sadd 'users', current_user.id.to_s
  end

  def del_online
    Redis.new.srem 'users', current_user.id.to_s
  end

end
