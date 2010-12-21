# encoding: utf-8
# set online users
class Users::RegistrationsController < Devise::RegistrationsController
  after_filter :add_online, :only => :create

  protected
  def add_online
    Redis.new.sadd 'users', @user.id.to_s
  end

end
