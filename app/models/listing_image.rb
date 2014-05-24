class ListingImage < ActiveRecord::Base
  include Loggy

  belongs_to :listing, touch: true, counter_cache: :images_count

  validates :listing, presence: true

  acts_as_list scope: :listing

  def full_public_id
    "v#{self.version}/#{self.public_id}.#{self.format}"
  end
end