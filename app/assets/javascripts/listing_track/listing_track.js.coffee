$(document).ready ->

  try
    if $(".track-listing-view").length > 0
      listing_id = $("a.checkout").data('listing-id')
      console.log "track listing view: #{listing_id}"
      async.waterfall [
        (callback) ->
          Tegu.TrackingApi.track_listing_view(listing_id, current_session, auth_token, callback)
        (data, callback) ->
          console.log data
      ]
  catch e

  try
    if $(".track-listing-peek").length > 0
      listing_ids = ($(object).data('listing-id') for object in $(".track-listing-peek"))
      console.log "track listing peek: #{listing_ids.join(',')}"
      async.waterfall [
        (callback) ->
          Tegu.TrackingApi.track_listing_peek(listing_ids.join(','), current_session, auth_token, callback)
        (data, callback) ->
          console.log data
      ]
  catch e

  try
    if $(".track-category-view").length > 0 and current_user > 0
      category_id = $(".category-nav").data('category-id')
      console.log "track category view: #{category_id}"
      return if category_id == 0
      async.waterfall [
        (callback) ->
          Tegu.TrackingApi.track_category_view(category_id, current_session, auth_token, callback)
        (data, callback) ->
          console.log data
      ]
  catch e
