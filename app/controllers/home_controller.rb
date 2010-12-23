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
      # answering
      if answering?(current_user.id)
        qa_id = answering_qa_id(current_user.id)
        qa = Qa.find(qa_id)
        qa.update_attributes! :a_content => content
        content = render_to_string(:partial => "answer", :locals => {:qa => qa})
        Juggernaut.publish "chat", :content => content
      # question
      elsif content.start_with?('#')
        if current_user.qas.askable?
          current_user.qas.create :content => content[1..-1]
          Juggernaut.publish "chat", :system => I18n.t('message.submit_question', :user => name)
        end
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
