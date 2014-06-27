module ApplicationHelper

  def category_cover_image(category, size=1440)
    cloudinary_url(category.cover_image.path)
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def listing_image_dimensions(image)
    "#{image.width} x #{image.height}"
  end

  def listing_image_thumbnail(image, size=200)
    cloudinary_url(image.full_public_id, transformation: [{width: size, height: size, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def listing_shipping_times(options={})
    ['1 business day', '1-2 business days', '1-3 business days', '3-5 business days', '1-2 weeks',
     '2-3 weeks', '3-4 weeks']
  end

  def user_avatar_image_profile(image, size=100)
    cloudinary_url(image.full_public_id, transformation: [{width: 200, height: 200, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def user_avatar_image_thumbnail(image, size=120)
    cloudinary_url(image.full_public_id, transformation: [{width: 120, height: 120, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def user_cover_image_profile(image, size=350)
    cloudinary_url(image.full_public_id, transformation: [{width: 350, height: 300, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end

  def website(s)
    s.gsub(/https?:\/\//, '') rescue s
  end
end
