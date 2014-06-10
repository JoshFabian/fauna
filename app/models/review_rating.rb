class ReviewRating < ActiveRecord::Base
  include Loggy

  belongs_to :review

  validates :name, presence: true
  validates :rating, presence: true, inclusion: {in: 1..5}
  validates :review, presence: true

end