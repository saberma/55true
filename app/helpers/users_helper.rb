module UsersHelper
  #@see:http://www.lukemelia.com/blog/archives/2010/01/17/redis-in-practice-whos-online/
  # Defining the keys
  def current_key
    key(Time.now.strftime("%M"))
  end

  def keys_in_last_5_minutes
    now = Time.now
    times = (0..5).collect {|n| now - n.minutes }
    times.collect{ |t| key(t.strftime("%M")) }
  end

  def key(minute)
    "online_users_minute_#{minute}"
  end

  # Tracking an Active User
  def track_user_id(id)
    key = current_key
    redis.sadd(key, id)
  end

  # Who's online
  def online_user_ids
    redis.sunion(*keys_in_last_5_minutes)
  end

  def redis
    Redis.new
  end
end
