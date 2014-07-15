class ReviewObserver < ActiveRecord::Observer
  observe Review, ReviewRating

  include Loggy

  def after_save(object)
    if object.is_a?(ReviewRating)
      update_review_rating(object.review)
    elsif object.is_a?(Review)
      # find associated payment and mark as reviewed
      payment = Payment.completed.where(listing_id: object.listing_id, buyer_id: object.user_id).first
      if payment.present?
        payment.update_attributes(reviewed: true)
      end
      # enqeue review job
      Backburner::Worker.enqueue(ReviewJob, Hashie::Mash.new)
    end
  rescue Exception => e
  end

  def after_destroy(object)
    if object.is_a?(ReviewRating)
      update_review_rating(object.review)
    end
  rescue Exception => e
  end

  protected

  def update_review_rating(review)
    review.update_attributes(avg_rating: review.ratings.average(:rating))
  end
end