$(document).ready ->

  $('label[for]').on 'click', (e) ->
    target = window[this.htmlFor]
    target.checked = !target.checked
    e.preventDefault()

  # listing edit form
  $("form.listing-review").validate
    onsubmit: true,
    submitHandler: (form) ->
      form_data = $("form.listing-review").serialize()
      listing_id = $("form.listing-review").data('listing-id')
      user_id = $("form.listing-review").data('user-id')
      console.log "listing:#{listing_id} review submit ..."
      async.waterfall [
        (callback) ->
          # create listing review
          Tegu.ListingApi.create_review(listing_id, form_data, auth_token, callback)
        (data, callback) ->
          # get user reviews route
          Tegu.UserRoutes.user_reviews_route(user_id, auth_token, callback)
        (url, callback) ->
          # console.log url
          window.location.href = url
      ]

