# == Schema Information
# Schema version: 20081103115406
#
# Table name: unanswered_questions
#
#  id          :integer(4)      not null, primary key
#  question_id :integer(4)      not null
#  play_time   :datetime        not null
#  checksum    :integer(4)      default(0), not null
#

class UnansweredQuestion < ActiveRecord::Base
  belongs_to :question

  named_scope :get, lambda {
    {
      :conditions => ['play_time < ?', MAX_ANSWER_TIME.ago],
      :limit => 1, :order => "id asc"
    }
  }

  def self.for(user=nil)
    unanswer_question = get.first
    if unanswer_question && unanswer_question.question.user == user
      unanswer_question.update_attributes(:play_time => Time.now, :checksum => rand(10000))
      q = unanswer_question.question
      q.checksum = unanswer_question.checksum
      q
    end
  end
end
