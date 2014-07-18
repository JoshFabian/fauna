class TrackObject

  def self.listing_seen!(listing_id, by_user_id)
    add("user:#{by_user_id}:listings:seen", listing_id)
  end

  def self.profile_seen!(user_id, by_user_id)
    return 0 if user_id == by_user_id
    add("user:#{by_user_id}:profiles:seen", user_id)
  end

  def self.flush
    redis.flushdb
  end

  protected

  # add the member to the set
  def self.add(key, member)
    return 0 if redis.sismember(key, member)
    redis.sadd(key, member) ? 1 : 0
  end

  def self.redis
    @@redis ||= Redis.new
  end
end