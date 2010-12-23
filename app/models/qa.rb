class Qa
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :user
  referenced_in :a_user, :class_name => 'User'

  field :content
  field :a_content

  after_create :async_receive

  def async_receive
    Resque.enqueue(Receive, self.id.to_s)
  end

end
