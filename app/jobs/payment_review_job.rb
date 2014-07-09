class PaymentReviewJob
  include Backburner::Queue
  include Loggy
  queue "payments"  # defaults to 'backburner-jobs' tube
  queue_priority 1000 # most urgent priority is 0
  queue_respond_timeout 100 # number of seconds before job times out

  def self.perform(mash)
    # find completed payments where user has not left review after 5 days
    object = Hashie::Mash.new
    Payment.completed.where(reviewed: false).where("completed_at <= ?", 5.days.ago).each do |payment|
      object[payment.buyer_id] = 0 if object[payment.buyer_id].blank?
      object[payment.buyer_id] += 1
    end
    # update user counter field
    object.each_pair do |user_id, count|
      # puts "user:#{user_id}:count:#{count}"
      User.update_counters(user_id, pending_listing_reviews: count)
    end
    # reset user counter field
    User.where.not(id: object.keys.map(&:to_i)).where("pending_listing_reviews > 0").each do |user|
      # puts "user:#{user.id}:#{user.pending_listing_reviews}"
      user.update_attributes(pending_listing_reviews: 0)
    end
    logger.post("tegu.app", log_data.merge({event: 'payment_review_job', object: object}))
    true
  end
end