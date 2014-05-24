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
      form_data = $("form.listing-edit").serialize()
      listing_id = $("form.listing-edit").data('listing-id')
      if listing_id == 0
        console.log('listing create ...')
        async.waterfall [
          (callback) ->
            # create listing
            Tegu.ListingApi.create(form_data, auth_token, callback)
          (data, callback) ->
            console.log data
        ]
      else
        console.log("listing:#{listing_id} update ...")
        async.waterfall [
          (callback) ->
            # update listing
            Tegu.ListingApi.update(listing_id, form_data, auth_token, callback)
          (data, callback) ->
            console.log data
            # jQuery.gritter.add({image: '/assets/success.png', title: 'User', text: 'Saved'})
        ]
