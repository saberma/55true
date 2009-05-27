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
      :limit => 1, :order => "sequence"
    }
  }

  #限制用户回答同一个问题
  named_scope :get_same, lambda { |user, question_id|
    {
      :conditions => ['player_id = ? and question_id = ?', user.id, question_id]
    }
  }

  def self.same(user, question_id)
    unanswer_question = get_same(user, question_id).first
    if unanswer_question 
      unanswer_question.update_attributes(:play_time => Time.now) 
      unanswer_question.question
    end
  end

  def self.for(user)
    unanswer_question = get(user).first
    if unanswer_question 
      unanswer_question.update_attributes(:play_time => Time.now, :player => user) 
      unanswer_question.question
    end
  end

  def self.create_from(question)
    self.create(
      :question => question, 
      :user => question.user, 
      :player => question.user,  
      :play_time => MAX_ANSWER_TIME.ago,
      :sequence => rand(1000)
    )
  end
end
