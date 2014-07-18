$(document).ready ->

  try
    if $("a.checkout").length > 0
      listing_id = $("a.checkout").data('listing-id')
      console.log "track listing view: #{listing_id}"
      async.waterfall [
        (callback) ->
          Tegu.TrackingApi.track_listing_view(listing_id, auth_token, callback)
        (data, callback) ->
          console.log data
      ]
  catch e
