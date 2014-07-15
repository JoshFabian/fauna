$(document).ready ->

  Tegu.ListingForm.init_currency()

  $("input.numeral").on 'blur', (e) ->
    try
      if !$(this).val().match(/^\$/)
        # prepend $
        $(this).val("$#{$(this).val()}")
      if $(this).val().match(/^\$\d+$/)
        # append zeros
        $(this).val("#{$(this).val()}.00")
    catch e

  # listing edit form
  $("form.listing-edit").validate
    onsubmit: true,
    submitHandler: (form) ->
      Tegu.ListingForm.disable_form()
      form_data = $("form.listing-edit").serialize()
      listing_id = $("form.listing-edit").data('listing-id')
      if listing_id == 0
        console.log('listing create ...')
        async.waterfall [
          (callback) ->
            # create listing
            Tegu.ListingApi.create(form_data, auth_token, callback)
          (data, callback) ->
            # console.log data
            Tegu.ListingApi.get_show_route(data.listing.id, auth_token, callback)
          (data, callback) ->
            # console.log data
            Tegu.ListingForm.enable_form()
            window.location.href = data.route
        ]
      else
        console.log("listing:#{listing_id} update ...")
        async.waterfall [
          (callback) ->
            # update listing
            Tegu.ListingApi.update(listing_id, form_data, auth_token, callback)
          (data, callback) ->
            # console.log data
            Tegu.ListingApi.get_show_route(listing_id, auth_token, callback)
          (data, callback) ->
            console.log data
            Tegu.ListingForm.enable_form()
            window.location.href = data.route
        ]

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
