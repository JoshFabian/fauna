class ListingLike < ActiveRecord::Base
  include Loggy

  validates :listing, presence: true
  validates :user, presence: true, uniqueness: {scope: :listing}

  belongs_to :listing, counter_cache: :likes_count
  belongs_to :user

  def self.like?(listing, user)
    listing.likes.where(user_id: user.respond_to?(:id) ? user.id : user).exists?
  rescue Exception => e
    false
  end

  def self.like!(listing, user)
    listing.likes.create!(user: user)
    true
  rescue Exception => e
    false
  end

  def self.unlike!(listing, user)
    listing.likes.find_by_user_id(user.respond_to?(:id) ? user.id : user).destroy
    true
  rescue Exception => e
    false
  end

  def self.toggle_like!(listing, user)
    if like?(listing, user)
      unlike!(listing, user)
    else
      like!(listing, user)
    end
    true
  rescue Exception => e
    false
  end

  def self.likes(listing)
    self.where(listing_id: listing.respond_to?(:id) ? listing.id : listing)
  end
end