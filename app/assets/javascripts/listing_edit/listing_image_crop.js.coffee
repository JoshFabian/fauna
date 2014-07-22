class Tegu.ImageCrop
  coords = {crop_h:0, crop_w:0, crop_x:0, crop_y:0}

  @init_jcrop: () ->
    $("#image-crop-modal img").Jcrop
      aspectRatio: 16 / 9
      boxWidth: 650
      minSize: [250, 27]
      onSelect: (c) ->
        # @image_crop_coords = c
        coords.crop_h = c.h
        coords.crop_w = c.w
        coords.crop_x = c.x
        coords.crop_y = c.y
        console.log coords

  @coords: () ->
    coords

  @valid_coords: () ->
    coords.crop_h > 0 and coords.crop_w > 0 ? true : false

$(document).ready ->

  image_crop_coords = {h:0, w:0, x:0, y:0}

  $(document).on 'click', '.image-crop', (e) ->
    e.preventDefault()
    image_id = $(this).data('image-id')
    console.log "open crop modal image:#{image_id} ..."
    async.waterfall [
      (callback) ->
        # show image preview
        Tegu.ListingModal.get_image_crop(image_id, callback)
      (data, callback) ->
        # console.log data
        Tegu.ListingModal.show_image_crop_modal(data)
        Tegu.ImageCrop.init_jcrop()
    ]

  $(document).on 'click', '.image-crop-save', (e) ->
    e.preventDefault()
    image_id = $(this).data('image-id')
    # console.log "save: #{JSON.stringify Tegu.ImageCrop.coords()}"
    if Tegu.ImageCrop.valid_coords()
      console.log "save cropped image:#{image_id} ... #{JSON.stringify Tegu.ImageCrop.coords()}"
      async.waterfall [
        (callback) ->
          # update listing image
          Tegu.ImageApi.update(image_id, {image: Tegu.ImageCrop.coords()}, auth_token, callback)
        (data, callback) ->
          console.log data
          Tegu.ListingModal.close_image_crop_modal()
      ]
