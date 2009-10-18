# == Schema Information
# Schema version: 20081103115406
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(255)     
#  remember_token            :string(255)     
#  crypted_password          :string(255)     
#  remember_token_expires_at :datetime        
#  last_login                :datetime        not null
#  questions_count           :integer(4)      default(0), not null
#  answers_count             :integer(4)      default(0), not null
#  photo_file_name           :string(255)     
#  photo_content_type        :string(255)     
#  photo_file_size           :integer(4)      
#  created_at                :datetime        
#  updated_at                :datetime        
#

require 'digest/sha1'
class User < ActiveRecord::Base
  attr_accessor :password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :password, :score
  
  has_many :questions
  has_many :answers
  has_many :unanswered_questions
  has_many :messages
  has_many :friendships, :order => 'friend_id desc'
  has_many :friends, :through => :friendships

  has_attached_file :photo, :url => "/:attachment/:class/:id.:extension",
    :default_url => "/images/:class/default.jpg",
    :path => ":rails_root/public/:attachment/:class/:id.:extension",
    :styles => {:original => "48x48#"}
  
  validates_presence_of     :login
  validates_length_of       :password, :maximum => 40
  validates_length_of       :login,    :maximum => 40
  validates_uniqueness_of   :login, :case_sensitive => false,
                            :allow_blank => true

  named_scope :today, lambda {
    {
      :select => 'distinct users.id',
      :joins => :answers,
      :conditions => ["answers.created_at >= ?", 24.hours.ago],
      :group => 'answers.user_id',
      :order => 'users.score desc'
    }
  }

  named_scope :limit, lambda {|limit|
    {:limit => limit}
  }

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif']
  validates_attachment_size :photo, :less_than => 2.megabytes
  
  before_save :encrypt_password
  before_create :init_property

  def head
    #test user
    return "/images/users/#{login}.jpg" if %w{po ben patpat}.include?(login)
    return "/images/users/forbid.gif" if forbid?
    photo.url
  end

  def forbid?
    score < 0
  end

  def self.admin
    User.find_by_login('55true管理员')
  end

  #首页今天谁在玩top50
  def self.today_top
    #特殊处理：双排序，保证页面显示的是按积分排序的
    self.find(self.today.limit(TODAY_USER_TOP_MAX), :order => 'score desc')
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def authenticated?(password)
    unencrypted_password == password
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = DES.encrypt("#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
    
  def encrypt_password
    return if password.blank?
    self.crypted_password = DES.encrypt(password)
  end
  
  def unencrypted_password
    return "" if crypted_password.blank?
    DES.decrypt(crypted_password)
  end
  
  def init_property
    self.last_login = DateTime.now
  end
end
