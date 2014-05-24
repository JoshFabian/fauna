module ApplicationHelper

  def listing_image_thumbnail(image, size=200)
    cloudinary_url(image.full_public_id, transformation: [{width: size, height: size, crop: 'fit'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}/#{size}"
  end
  
end
