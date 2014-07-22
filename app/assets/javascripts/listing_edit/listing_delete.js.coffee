$(document).ready ->

  $(document).on 'click', 'a.image-delete', (e) ->
    e.preventDefault()
    return if !$(this).hasClass('editable')
    listing_id = $(this).data('listing-id')
    image_id = $(this).data('image-id')
    console.log "listing:#{listing_id}:image:#{image_id} delete ..."
    async.waterfall [
      (callback) ->
        # delete image
        Tegu.ListingApi.delete_image(listing_id, image_id, auth_token, callback)
      (data, callback) ->
        console.log data
        # get images
        Tegu.ListingForm.get_images(listing_id, callback)
      (data, callback) ->
        # console.log data
        # replace images
        Tegu.ListingForm.replace_images(data)
        # init cloudinary
        Tegu.ListingForm.init_cloudinary()
    ]
