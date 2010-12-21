class HomeController < ApplicationController
  def index
  end

  def publish
    Juggernaut.publish "chat", params[:msg]
    render :nothing => true
  end
end
