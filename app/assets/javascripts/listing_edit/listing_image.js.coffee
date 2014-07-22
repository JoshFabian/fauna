class Tegu.ListingImage
  cropped_images = {}
  new_images = []

  @crop_cur_image: (id, image) ->
    cropped_images[id] = image

  @crop_new_image: (image) ->
    [first_image, ..., last_image] = new_images
    $.extend(last_image, image)

  @cropped_images: () ->
    cropped_images

  @new_image: (image) ->
    new_images.push(image)

  @new_images: () ->
    new_images
