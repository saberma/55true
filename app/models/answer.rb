# == Schema Information
# Schema version: 20081103115406
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  content     :string(255)     default(""), not null
#  question_id :integer(4)      not null
#  user_id     :integer(4)      not null
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user, :counter_cache => true
  
  validates_presence_of     :content

  named_scope :of, lambda {|user|
    {:conditions => ["user_id = ?", user.id]}
  }
  named_scope :limit, lambda {|limit|
    {:limit => limit}
  }

  def validate_on_create
    errors.add_to_base(I18n.translate('activerecord.errors.messages.timeout')) if timeout?
  end

  before_create do |answer|
    answer.question.update_attribute(:is_answered, true)
  end

  after_create do |answer|
    UnansweredQuestion.delete_all(["question_id = ?", answer.question])
  end

  after_destroy do |answer|
    question = answer.question
    question.update_attribute :is_answered, false
    UnansweredQuestion.create_from question
  end

  def timeout?
    uq = UnansweredQuestion.find_by_question_id question.id
    uq.player != user
  end
end
