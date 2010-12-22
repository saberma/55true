class User
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
    errors.add(:code, I18n.t('activemodel.errors.messages.invite_mismatch')) if code.blank? or !Code.where(:code => code).first
  end

  def name
    login.blank? ? email.sub(/@.+/,'') : login
  end

  def del_code
    Code.find(code).destroy
  end

  def get_codes
    10.times do
      self.codes.create
    end
  end
end
