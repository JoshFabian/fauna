module ApplicationHelper

  def category_cover_image(category, size=1440)
    cloudinary_url(category.cover_image.path)
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

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

  def user_avatar_image_thumbnail(image, size=60)
    cloudinary_url(image.full_public_id, transformation: [{width: 60, height: 60, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def user_cover_image_profile(image, size=350)
    cloudinary_url(image.full_public_id, transformation: [{width: 350, height: 300, crop: 'fit'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def website(s)
    s.gsub(/https?:\/\//, '') rescue s
  end
end
