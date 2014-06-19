class ReviewObserver < ActiveRecord::Observer
  observe Review, ReviewRating

  include Loggy

  def after_save(object)
    if object.is_a?(ReviewRating)
      update_review_rating(object.review)
    elsif object.is_a?(Review)
      # find associated payment and mark as reviewed
      payment = Payment.where(listing_id: object.listing_id, buyer_id: object.user_id).first
      if payment.present?
        payment.update_attributes(reviewed: true)
      end
    end
  rescue Exception => e
  end

  def after_destroy(object)
    if object.is_a?(ReviewRating)
      update_review_rating(object.review)
    end
  rescue Exception => e
  end

  def self.set_pending_reviews(options={})
    # find completed payments where user has not left review after 5 days
    mash = Hashie::Mash.new
    Payment.completed.where(reviewed: false).where("completed_at <= ?", 5.days.ago).each do |payment|
      mash[payment.buyer_id] = 0 if mash[payment.buyer_id].blank?
      mash[payment.buyer_id] += 1
    end
    # update user counter field
    mash.each_pair do |user_id, count|
      # puts "user:#{user_id}:count:#{count}"
      User.update_counters(user_id, pending_listing_reviews: count)
    end
    # reset user counter field
    User.where.not(id: mash.keys.map(&:to_i)).where("pending_listing_reviews > 0").each do |user|
      # puts "user:#{user.id}:#{user.pending_listing_reviews}"
      user.update_attributes(pending_listing_reviews: 0)
    end
  end

  protected

  def update_review_rating(review)
    review.update_attributes(avg_rating: review.ratings.average(:rating))
  end
end