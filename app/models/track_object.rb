class TrackObject

  def self.listing_view!(listing, options={})
    id = listing.is_a?(Listing) ? listing.id : listing
    by_id = by(options)
    i = add("user:#{by_id}:listings:view", id)
    if i == 1
      listing = listing.is_a?(Listing) ? listing : Listing.find_by_id(listing)
      listing.increment!(:views_count)
    end
    i
  end

  def self.listing_working_set(options={})
    by_id = by(options)
    key = "user:#{by_id}:listings:view"
    redis.smembers(key).map(&:to_i) rescue []
  end

  def self.profile_view!(user, options={})
    id = user.is_a?(User) ? user.id : user
    by_id = by(options)
    return 0 if options[:by].blank? or id == by_id
    i = add("user:#{by_id}:profiles:view", id)
    if i == 1
      user = user.is_a?(User) ? user : User.find_by_id(user)
      user.increment!(:views_count)
    end
    i
  end

  def self.profile_working_set(options={})
    by_id = by(options)
    key = "user:#{by_id}:profiles:view" 
    redis.smembers(key).map(&:to_i) rescue []
  end

  def self.by(options={})
    options[:by].respond_to?(:id) ? options[:by].id : options[:by]
  rescue Exception => e
    0
  end

  def self.flush
    redis.flushdb
  end

  def self.default_ttl
    60*10
  end

  protected

  # add the member to the set
  def self.add(key, member)
    return 0 if redis.sismember(key, member)
    result = redis.sadd(key, member) ? 1 : 0
    redis.expire(key, default_ttl)
    result
  rescue Exception => e
    0
  end

  def self.redis
    @@redis ||= Redis.new
  end
end