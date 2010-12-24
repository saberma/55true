class ApplicationController < ActionController::Base
  protect_from_forgery
  include UsersHelper

  protected
  def add_online
    if user_signed_in?
      track_user_id current_user.id.to_s
      content = render_to_string(:partial => "home/user", :object => current_user)
      Juggernaut.publish "chat", :online => "#user_#{current_user.id}", :content => content
    end
  end

  def del_online
    lost_user_id current_user.id.to_s
    content = render_to_string(:partial => "home/user", :object => current_user)
    Juggernaut.publish "chat", :offline => "#user_#{current_user.id}"
  end

end
