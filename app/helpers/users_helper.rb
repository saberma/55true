module UsersHelper
  #@see:http://www.lukemelia.com/blog/archives/2010/01/17/redis-in-practice-whos-online/
  # Defining the keys
  def current_key
    key(Time.now.strftime("%M"))
  end

  def keys_in_last_minutes
    now = Time.now
    times = (0..10).collect {|n| now - n.minutes }
    times.collect{ |t| key(t.strftime("%M")) }
  end

  def key(minute)
    "online_users_minute_#{minute}"
  end

  # Tracking an Active User
  def track_user_id(id)
    key = current_key
    redis.sadd(key, id)
    #redis will reset ttl after modified
    redis.expire(key, 10.minutes)
  end

  # Delete an User
  def lost_user_id(id)
    keys_in_last_minutes.each do |key|
      redis.srem key, id
      redis.expire(key, 10.minutes)
    end
  end

  # Who's online
  def online_user_ids
    redis.sunion(*keys_in_last_minutes)
  end

  def answering?(user_id)
    redis.hexists 'answering', user_id.to_s
  end

  def answering(user_id, qa_id)
    redis.hset 'answering', user_id.to_s, qa_id.to_s
  end

  def answering_qa_id(user_id)
    redis.hget 'answering', user_id.to_s
  end

  def redis
    Resque.redis
  end
end
