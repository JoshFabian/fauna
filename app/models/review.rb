class Review < ActiveRecord::Base
  include Loggy

  belongs_to :listing
  belongs_to :user

  has_many :ratings, class_name: "ReviewRating", dependent: :destroy

  validates :body, presence: true
  validates :listing, presence: true
  validates :user, presence: true, uniqueness: {scope: :listing}

  def as_json(options={})
    options ||= {}
    super(except: [:created_at, :data, :updated_at])
  end

  def stars
    avg_rating.ceil
  end
end