$(document).ready ->

  image_crop_coords = {x: 0, y:0, h:0, w:0}

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
        $("#image-crop-modal").html(data)
        $("#image-crop-modal").foundation('reveal', 'open')
        $("#image-crop-modal img").Jcrop
          onSelect: (c) ->
            image_crop_coords = c
            console.log c
    ]

  $(document).on 'click', '.image-crop-save', (e) ->
    e.preventDefault()
    image_id = $(this).data('image-id')
    if image_crop_coords.h > 0 and image_crop_coords.w > 0
      image_crop_coords.crop_h = image_crop_coords.h
      image_crop_coords.crop_w = image_crop_coords.w
      image_crop_coords.crop_x = image_crop_coords.x
      image_crop_coords.crop_y = image_crop_coords.y
      console.log "save cropped image:#{image_id} ... #{JSON.stringify image_crop_coords}"
      async.waterfall [
        (callback) ->
          # update listing image
          Tegu.ImageApi.update(image_id, {image: image_crop_coords}, auth_token, callback)
        (data, callback) ->
          console.log data
          $("#image-crop-modal").foundation('reveal', 'close')
      ]
