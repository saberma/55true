class User
  INVITE_CODE = 'bd6s79'
  include Mongoid::Document
  #include Formtastic::I18n::Naming
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  references_many :codes

  field :login
  attr_accessor :code

  before_create :get_codes
  after_create :del_code

  validate :validate_code

  def validate_code
    if code.blank? or !Code.where(:code => code).first
      errors.add(:code, I18n.t('activemodel.errors.messages.invite_mismatch')) unless code == INVITE_CODE
    end
  end

  def name
    login.blank? ? email.sub(/@.+/,'') : login
  end

  def del_code
    c = Code.where(:code => code).first
    c.destroy if c
  end

  def get_codes
    10.times do
      self.codes.create :code => Code.random
    end
  end
end
