# == Schema Information
# Schema version: 20081103115406
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  email                     :string(255)     
#  login                     :string(255)     
#  remember_token            :string(255)     
#  crypted_password          :string(255)     
#  remember_token_expires_at :datetime        
#  last_login                :datetime        
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
  
  EMAIL_REGEX = /\A[A-Z0-9\._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}\z/i
  
  attr_accessor :password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password
  
  has_many :questions
  has_many :answers

  has_attached_file :photo, :url => "/:attachment/:class/:id.:extension",
    :default_url => "/:attachment/:class/default.jpg",
    :path => ":rails_root/public/:attachment/:class/:id.:extension",
    :styles => {:original => "48x48#"}
  
  validates_presence_of     :login, :email
  validates_presence_of     :password 
  validates_length_of       :password, :within => 4..40
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_format_of       :email,
                            :with => EMAIL_REGEX,
                            :message => "必须是正确的Email地址"
  validates_uniqueness_of   :login, :email, :case_sensitive => false

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :photo, :less_than => 2.megabytes
  
  before_save :encrypt_password

  def head
    return "/photos/users/#{login}.jpg" if %w{po ben patpat}.include?(login)
    photo.url
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
    self.remember_token            = DES.encrypt("#{email}--#{remember_token_expires_at}")
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
    DES.decrypt(crypted_password)
  end
end
