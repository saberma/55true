class HomeController < ApplicationController
  def index
    @online = []
    ids = Redis.new.smembers('users')
    @online = User.find(ids) unless ids.empty?
  end

  def publish
    Juggernaut.publish "chat", params[:msg]
    render :nothing => true
  end
end
