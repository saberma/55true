# == Schema Information
# Schema version: 20081103115406
#
# Table name: unanswered_questions
#
#  id          :integer(4)      not null, primary key
#  question_id :integer(4)      not null
#  user_id     :integer(4)      not null
#  player_id   :integer(4)      not null
#  play_time   :datetime        not null
#

class UnansweredQuestion < ActiveRecord::Base
  belongs_to :question
  #question's creator,user can't get question belong to himself
  belongs_to :user
  #who get the question
  belongs_to :player, :class_name => 'User', :foreign_key => 'player_id'
  

  named_scope :get, lambda { |user|
    {
            :conditions => ['play_time < ? and user_id != ?', MAX_ANSWER_TIME.ago, user.id],
      :limit => 1, :order => "id asc"
    }
  }

  def self.for(user)
    unanswer_question = get(user).first
    if unanswer_question 
      unanswer_question.update_attributes(:play_time => Time.now, :player => user) 
      unanswer_question.question
    end
  end
end
