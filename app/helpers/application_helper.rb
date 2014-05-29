module ApplicationHelper

  def listing_image_thumbnail(image, size=200)
    cloudinary_url(image.full_public_id, transformation: [{width: size, height: size, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def user_avatar_image_profile(image, size=100)
    cloudinary_url(image.full_public_id, transformation: [{width: 100, height: 100, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def user_cover_image_profile(image, size=350)
    cloudinary_url(image.full_public_id, transformation: [{width: 350, height: 300, crop: 'fit'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

end
