class ReviewRating < ActiveRecord::Base
  include Loggy

  belongs_to :review

  validates :name, presence: true
  validates :rating, presence: true, inclusion: {in: 1..5}
  validates :review, presence: true

  before_validation(on: :create) do
    if self.name.present? and !self.name.match(/communication|description|shipping/i)
      self.errors[:base].push("invalid name")
    end
  end
end