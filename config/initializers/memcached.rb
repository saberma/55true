#memcached
require 'memcache'
@@host = '127.0.0.1'
@@memcache_server = MemCache.new(@@host)

#空数组
EMPTY_ARRAY = "e_a"

def memcache(key)
  #fixed:ArgumentError (undefined class/module Answer)
  Answer
  output = mem_cache_get(key)
  unless output
    output = yield
    #fixed:empty array will not be store
    output = EMPTY_ARRAY if output == []
    mem_cache_set(key, output, 30.minutes)
  end
  output = [] if (output == EMPTY_ARRAY)
  return output
end

def expire_memcache(key)
  no_error { @@memcache_server.delete(key) }
end

def clear_memcache
  no_error { @@memcache_server.flush_all }
end

def mem_cache_get(key)
  begin
    @@memcache_server.get(key)
  rescue MemCache::MemCacheError
    new_server
  end
end

def mem_cache_set(key, output, expire)
  begin
    @@memcache_server.set(key, output, expire)
  rescue MemCache::MemCacheError
    new_server
  end
end

def new_server
  no_error { @@memcache_server = MemCache.new(@@host); nil }
end

def no_error
  begin
    yield
  rescue
  end
end
