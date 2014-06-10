class ReviewObserver < ActiveRecord::Observer
  observe ReviewRating

  include Loggy

  def after_save(object)
    if object.is_a?(ReviewRating)
      update_review_rating(object.review)
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