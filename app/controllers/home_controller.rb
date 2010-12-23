class HomeController < ApplicationController
  before_filter :add_online

  def index
    @online = []
    ids = online_user_ids
    @online = User.find(ids) unless ids.empty?
  end

  def publish
    if user_signed_in?
      content = params[:content]
      name = current_user.name
      # question
      if content.start_with?('#')
        @qa = current_user.qas.create :content => content[1..-1]
        Juggernaut.publish "chat", :system => I18n.t('message.submit_question', :user => name)
      else
        content = render_to_string(:partial => "message", :locals => {:user => name, :content => content})
        Juggernaut.publish "chat", :content => content
      end
      render :nothing => true
    else
    end
  end

  def add_online
    track_user_id current_user.id.to_s if user_signed_in?
  end
end
