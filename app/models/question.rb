# == Schema Information
# Schema version: 20081103115406
#
# Table name: questions
#
#  id          :integer(4)      not null, primary key
#  content     :string(255)     default(""), not null
#  is_answered :boolean(1)      not null
#  user_id     :integer(4)      not null
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Question < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  has_one :answer, :dependent => :destroy

  validates_presence_of     :content
  validates_length_of       :content, :maximum => 120, :allow_nil => true
  
  named_scope :unanswer, :conditions => ['is_answered = ?', false], :order => "updated_at desc"
  named_scope :answered, :conditions => ['is_answered = ?', true], :order => "updated_at desc"
  #homepage dynamic refresh
  named_scope :newer, lambda {|updated_at|
    {
      :conditions => ['is_answered = ? and updated_at > ?', true, updated_at], 
      :order => "updated_at",
      :limit => 1
    }
  }
  named_scope :of, lambda {|user|
    {:conditions => ['user_id = ?', user.id]}
  }
  named_scope :not_belong_to, lambda {|user|
    {:conditions => ['user_id != ?', user.id]}
  }
  named_scope :limit, lambda {|limit|
    {:limit => limit}
  }
  named_scope :gt, lambda {|updated_at|
    {:conditions => ['updated_at > ?', updated_at]}
  }

  def self.per_page
    20
  end


  after_create do |question|
    question.user.increment!(:score,PLAY_SCORE)
    UnansweredQuestion.create_from question
  end
  
  after_destroy do |question|
    question.user.decrement!(:score,PUNISH_SCORE)
    uq = UnansweredQuestion.find_by_question_id(question.id)
    uq.destroy if uq
  end

end
