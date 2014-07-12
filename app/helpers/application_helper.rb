module ApplicationHelper

  def category_cover_image(category, width=1440)
    cloudinary_url(category.cover_image.path)
  rescue Exception => e
    "http://www.placehold.it/#{width}x440"
  end

  def listing_image_dimensions(image)
    "#{image.width} x #{image.height}"
  end

  def listing_image_thumbnail(image, size=200)
    cloudinary_url(image.full_public_id, transformation: [{width: size, height: size, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/#{size}x#{size}"
  end

  def listing_image_tile(image)
    cloudinary_url(image.full_public_id, transformation: [{width: 235, height: 200, crop: 'fill'}])
  rescue Exception => e
    "http://www.placehold.it/235x200/fff&text=Image"
  end

  def listing_shipping_prices_options(listing, options={})
    listing.shipping_prices.collect do |hash|
      if hash[1].present?
        location = string_titleize(hash[0])
        ["#{location} : $#{hash[1]}", hash[0], :'data-shipping-price' => hash[1]]
      else
        nil
      end
    end.compact
  end

  def listing_shipping_times(options={})
    ['1 business day', '1-2 business days', '1-3 business days', '3-5 business days', '1-2 weeks', '2-3 weeks',
     '3-4 weeks']
  end

  def plan_display_name(plan)
    s = "#{plan.name}"
    if !plan.subscription?
      s += " - #{number_to_currency(plan.amount/100.0, precision: 2)}"
    end
    if plan.savings.present?
      s += " (save #{plan.savings})"
    end
    s
  end

  def string_titleize(s)
    s == s.downcase ? s.titleize : s
  end

  def today_time(time_at)
    if time_at > Time.zone.now.beginning_of_day
      "Today at #{time_at.to_s(:time_ampm)}"
    elsif time_at > 1.day.ago.beginning_of_day
      "Yesterday at #{time_at.to_s(:time_ampm)}"
    else
      time_at.to_s(:datetime_tiny)
    end
  rescue Exception => e
    ''
  end

  def user_avatar_image_thumbnail(image, size=120)
    cloudinary_url(image.full_public_id, transformation: [{width: size, height: size, crop: 'fill'}])
  rescue Exception => e
    "http://res.cloudinary.com/tegu/image/upload/c_fill,h_#{size},w_#{size}/v1405184238/avatar_default.jpg"
  end

  def user_cover_image_profile(position, image, width=350, height=300)
    cloudinary_url(image.full_public_id, transformation: [{width: width, height: height, crop: 'fill'}])
  rescue Exception => e
    # use default cover images
    case position
    when 1
      "http://res.cloudinary.com/tegu/image/upload/c_fill,h_300,w_350/v1405175897/coverimage1.jpg"
    when 2
      "http://res.cloudinary.com/tegu/image/upload/c_fill,h_300,w_350/v1405175811/coverimage2.jpg"
    when 3
      "http://res.cloudinary.com/tegu/image/upload/c_fill,h_300,w_350/v1405175381/coverimage3.png"
    else
      "http://res.cloudinary.com/tegu/image/upload/c_fill,h_300,w_350/v1405175897/coverimage1.jpg"
    end
  end

  def website(s)
    s.gsub(/https?:\/\//, '') rescue s
  end
end
