# encoding: utf-8
# set online users
class Users::RegistrationsController < Devise::RegistrationsController
  after_filter :add_online, :only => :create

  protected
  def add_online
    track_user_id current_user.id.to_s if user_signed_in?
  end

end
