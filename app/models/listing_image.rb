class ListingImage < ActiveRecord::Base
  include Loggy

  belongs_to :listing, touch: true, counter_cache: :images_count

  validates :listing, presence: true

  acts_as_list scope: :listing

  def cropped?
    return true if self.crop_h > 0 and self.crop_w > 0
  end

  def crop_transform
    "x_#{crop_x},y_#{crop_y},w_#{crop_w},h_#{crop_h},c_crop"
  end

  def full_public_id
    "v#{self.version}/#{self.public_id}.#{self.format}"
  end
end