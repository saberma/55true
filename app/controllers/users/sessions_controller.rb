# encoding: utf-8
# set online users
class Users::SessionsController < Devise::SessionsController
  before_filter :del_online, :only => :destroy
  after_filter :add_online, :only => :create

  protected
  def add_online
    track_user_id current_user.id.to_s if user_signed_in?
  end

  def del_online
    lost_user_id current_user.id.to_s
  end

end
