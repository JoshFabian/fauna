$(document).ready ->

  try
    if $(".track-listing-view").length > 0
      listing_id = $("a.checkout").data('listing-id')
      console.log "track listing view: #{listing_id}"
      async.waterfall [
        (callback) ->
          Tegu.TrackingApi.track_listing_view(listing_id, auth_token, callback)
        (data, callback) ->
          console.log data
      ]
  catch e

  try
    if $(".category-nav").length > 0
      category_id = $(".category-nav").data('category-id')
      console.log "track category view: #{category_id}"
      return if category_id == 0
      async.waterfall [
        (callback) ->
          Tegu.TrackingApi.track_category_view(category_id, auth_token, callback)
        (data, callback) ->
          console.log data
      ]
  catch e
