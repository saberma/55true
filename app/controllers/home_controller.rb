class HomeController < ApplicationController

  def index
    @online = []
    ids = online_user_ids
    @online = User.find(ids) unless ids.empty?
  end

  def publish
    if user_signed_in?
      Juggernaut.publish "chat", :name => current_user.name, :time => Time.now.to_s(:short), :msg => params[:msg]
      render :nothing => true
    else
    end
  end
end
