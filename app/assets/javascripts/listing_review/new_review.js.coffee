$(document).ready ->

  $('label[for]').on 'click', (e) ->
    target = window[this.htmlFor]
    target.checked = !target.checked
    e.preventDefault()

  # listing edit form
  $("form.listing-review").validate
    onsubmit: true,
    submitHandler: (form) ->
      console.log "listing review submit"
      form_data = $("form.listing-review").serialize()
      listing_id = $("form.listing-review").data('listing-id')
      async.waterfall [
        (callback) ->
          # create listing review
          Tegu.ListingApi.create_review(listing_id, form_data, auth_token, callback)
        (data, callback) ->
          console.log data
      ]

