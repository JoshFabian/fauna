$(document).ready ->

  Tegu.ListingForm.init_currency()

  $("#listing_description").redactor({
    buttons: ['bold', 'italic', 'unorderedlist', 'orderedlist', 'link', 'horizontalrule']
  })

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
            Tegu.ListingRoute.show_route(current_user_slug, data.listing.id, auth_token, callback)
          (url, callback) ->
            Tegu.ListingForm.enable_form()
            window.location.href = url
        ]
      else
        console.log("listing:#{listing_id} update ...")
        async.waterfall [
          (callback) ->
            # update listing
            Tegu.ListingApi.update(listing_id, form_data, auth_token, callback)
          (data, callback) ->
            # console.log data
            Tegu.ListingRoute.show_route(current_user_slug, listing_id, auth_token, callback)
          (url, callback) ->
            Tegu.ListingForm.enable_form()
            window.location.href = url
        ]

  $("form.listing-edit input[type='submit']").on 'click', (e) ->
    listing_form = $(this).closest('form')
    image_count = $(listing_form).find(".image-grid li:not(.empty) img").length
    console.log "listing images:#{image_count} ..."
    if image_count == 0
      e.preventDefault()
      # validate form to show validate errors
      $(listing_form).valid()
      # show custom error message
      Tegu.ListingForm.show_no_images_error_message()
    else
      # hide error message
      Tegu.ListingForm.hide_no_images_error_message()

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
