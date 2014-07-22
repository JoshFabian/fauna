class Tegu.ImageCrop
  coords = {crop_h:0, crop_w:0, crop_x:0, crop_y:0}

  @coords: () ->
    coords

  @get_modal: (image_id, image_url, callback=null) ->
    $.ajax "/listing_modals/crop_image.js?image_id=#{image_id}&image_url=#{image_url}",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @open_modal: (data) ->
    $(".listing-image-crop").html(data)
    $(".listing-image-crop").foundation('reveal', 'open')

  @close_modal: () ->
    $(".listing-image-crop").foundation('reveal', 'close')

  @init_modal: () ->
    $("#image-crop-modal img").Jcrop
      boxWidth: 650
      minSize: [300, 200]
      setSelect: [100, 100, 500, 50]
      onSelect: (c) ->
        coords.crop_h = c.h
        coords.crop_w = c.w
        coords.crop_x = c.x
        coords.crop_y = c.y

  @save_coords: (image_id) ->
    if coords.crop_h > 0 and coords.crop_w > 0
      console.log "saving image:#{image_id} coords:#{JSON.stringify coords} ..."
      if image_id == 0
        # crop a new image
        Tegu.ListingImage.crop_new_image(coords)
      else
        # crop a current image
        Tegu.ListingImage.crop_cur_image(image_id, coords)

  @valid_coords: () ->
    coords.crop_h > 0 and coords.crop_w > 0 ? true : false

$(document).ready ->

  $(document).on 'click', '.image-crop', (e) ->
    e.preventDefault()
    image_id = $(this).data('image-id')
    image_url = $(this).data('image-url')
    console.log "get crop modal image:#{image_id} ..."
    async.waterfall [
      (callback) ->
        # get modal
        Tegu.ImageCrop.get_modal(image_id, image_url, callback)
      (data, callback) ->
        # console.log data
        # open modal
        Tegu.ImageCrop.open_modal(data)
        # init modal
        Tegu.ImageCrop.init_modal()
    ]

  $(document).on 'click', '.image-crop-save', (e) ->
    e.preventDefault()
    image_id = $(this).data('image-id')
    Tegu.ImageCrop.save_coords(image_id)
    Tegu.ImageCrop.close_modal()
