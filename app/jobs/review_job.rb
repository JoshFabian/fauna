class ReviewJob
  include Backburner::Queue
  include Loggy
  queue "reviews"  # defaults to 'backburner-jobs' tube
  queue_priority 1000 # most urgent priority is 0
  queue_respond_timeout 100 # number of seconds before job times out

  def self.perform(hash)
    # find completed payments where user has not left review after 5 days
    key = rand(2**10)
    object = Hashie::Mash.new
    payments = Payment.completed.where(reviewed: false).where("completed_at <= ?", 5.days.ago)
    if hash['payment_id'].present?
      # scope payments query
      payments = payments.where(id: hash['payment_id'])
    end
    payments.each do |payment|
      object[payment.buyer_id] = object[payment.buyer_id].to_i + 1
      logger.post("tegu.job", log_data.merge({event: 'job.review', payment_id: payment.id,
        user_id: payment.buyer_id, message: 'payment is missing review', key: key}))
    end
    # update user counter field
    object.each_pair do |user_id, count|
      change = count - User.find(user_id).pending_listing_reviews
      # puts "user:#{user_id}:count:#{count}:change:#{change}"
      User.update_counters(user_id, pending_listing_reviews: change) if change != 0
    end
    if hash['payment_id'].blank?
      # reset user counter field
      User.where.not(id: object.keys.map(&:to_i)).where("pending_listing_reviews > 0").each do |user|
        # puts "user:#{user.id}:#{user.pending_listing_reviews}"
        user.update_attributes(pending_listing_reviews: 0)
      end
    end
    true
  end
end