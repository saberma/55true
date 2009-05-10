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
  has_one :answer

  validates_presence_of     :content
  
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
    5
  end


  after_create do |question|
    UnansweredQuestion.create(
      :question => question, 
      :user => question.user, 
      :player => question.user,  
      :play_time => MAX_ANSWER_TIME.ago,
      :sequence => rand(1000)
    )
  end

end
