$(document).ready ->

  try
    if $("form.listing-edit").length > 0
      # init listing id
      Tegu.ListingForm.set_listing_id($("form.listing-edit").data('listing-id'))
  catch e

  # listing edit form
  $("form.listing-edit").validate
    onsubmit: true,
    ignore: ".new.step2"
    submitHandler: (form) ->
      Tegu.ListingForm.disable_form()
      listing_id = Tegu.ListingForm.get_listing_id()
      form_data = $("form.listing-edit").serialize()
      if listing_id == 0
        console.log "listing:#{listing_id} create ..."
        async.waterfall [
          (callback) ->
            # create listing
            Tegu.ListingApi.create(form_data, auth_token, callback)
          (data, callback) ->
            console.log "listing:#{data.listing.id} created"
            # set listing id
            Tegu.ListingForm.set_listing_id(data.listing.id)
            # update form
            Tegu.ListingForm.change_new_state(data.listing.id)
            Tegu.ListingForm.change_price_constraint()
            # enable form
            Tegu.ListingForm.enable_form('Create Listing')
        ]
      else
        console.log "listing:#{listing_id} update ..."
        async.waterfall [
          (callback) ->
            # update listing
            Tegu.ListingApi.update(listing_id, form_data, auth_token, callback)
          (data, callback) ->
            # update listing images (cropping)
            Tegu.ListingApi.update_images(listing_id, {images: Tegu.ListingImage.cropped_images()}, auth_token, callback)
          (data, callback) ->
            # console.log data
            if data.listing.state == 'draft'
              console.log "listing:#{listing_id} is a draft ..."
              Tegu.ListingApi.put_event(listing_id, 'approve', auth_token, callback)
            else
              callback(null, data)
          (data, callback) ->
            Tegu.ListingRoute.check_share_route(current_user_slug, listing_id, auth_token, callback)
          (url, callback) ->
            Tegu.ListingForm.enable_form()
            window.location.href = url
        ]

  # in new state, try to save listing when category and title are set
  $(document).on 'blur', "form.listing-edit.new .new.step1", (e) ->
    listing_id = Tegu.ListingForm.get_listing_id()
    listing_form = $(this).closest('form')
    console.log "listing:#{listing_id} new check ..."
    # validate form to show validate errors
    if $(listing_form).valid()
      console.log "listing:#{listing_id} new save ..."
      # turn off handlers
      $(this).off('blur')
      $(this).off('change')
      # submit form
      Tegu.ListingForm.disable_form()
      Tegu.ListingForm.submit_form()

  $(document).on 'click', "form.listing-edit input[type='submit']", (e) ->
    listing_form = $(this).closest('form')
    # skip new objects
    return if $(listing_form).hasClass('new')
    listing_id = Tegu.ListingForm.get_listing_id()
    image_count = $(listing_form).find(".image-grid li:not(.empty) img").length
    console.log "listing:#{listing_id} image count:#{image_count} ..."
    if image_count == 0
      e.preventDefault()
      # validate form to show validate errors
      $(listing_form).valid()
      # show custom error message
      Tegu.ListingForm.show_images_error_message()
    else
      # hide error message
      Tegu.ListingForm.hide_images_error_message()
