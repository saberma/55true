class HomeController < ApplicationController

  def index
    @online = []
    ids = online_user_ids
    @online = User.find(ids) unless ids.empty?
  end

  def publish
    if user_signed_in?
      msg = params[:msg]
      # question
      if msg.start_with?('#')
        @qa = current_user.qas.create :content => msg[1..-1]
        Juggernaut.publish "chat", :name => current_user.name, :time => Time.now.to_s(:short), :msg => I18n.t('message.submit_question')
      else
        Juggernaut.publish "chat", :name => current_user.name, :time => Time.now.to_s(:short), :msg => params[:msg]
      end
      render :nothing => true
    else
    end
  end
end
