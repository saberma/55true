class Qa
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :user
  referenced_in :a_user, :class_name => 'User'

  field :content
  field :a_content

  after_create :async_receive
  before_update :del_redis_answering

  def async_receive
    Resque.enqueue(Receive, self.id.to_s)
  end

  def del_redis_answering
    Resque.redis.hdel 'answering', a_user_id.to_s
  end

  def self.askable?
    where(:a_user_id => nil).size < 5
  end
end
