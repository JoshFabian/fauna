class Tegu.ListingTrack
  @track_category_view: (category_id) ->
    async.waterfall [
      (callback) ->
        Tegu.TrackingApi.track_category_view(category_id, current_session, auth_token, callback)
      (data, callback) ->
        console.log data
    ]

  @track_listing_peeks: (listing_ids) ->
    async.waterfall [
      (callback) ->
        Tegu.TrackingApi.track_listing_peek(listing_ids.join(','), current_session, auth_token, callback)
      (data, callback) ->
        console.log data
    ]

  @track_listing_view: (listing_id) ->
    async.waterfall [
      (callback) ->
        Tegu.TrackingApi.track_listing_view(listing_id, current_session, auth_token, callback)
      (data, callback) ->
        console.log data
    ]

$(document).ready ->

  try
    if $(".track-listing-peek").length > 0
      listing_ids = ($(object).data('listing-id') for object in $(".track-listing-peek"))
      console.log "track listing peek: #{listing_ids.join(',')}"
      Tegu.ListingTrack.track_listing_peeks(listing_ids)
  catch e

  try
    if $(".track-listing-view").length > 0
      listing_id = $(".track-listing-view:first").data('listing-id')
      console.log "track listing view: #{listing_id}"
      Tegu.ListingTrack.track_listing_view(listing_id)
  catch e

  try
    if $(".track-category-view").length > 0 and current_user > 0
      category_id = $(".category-nav").data('category-id')
      console.log "track category view: #{category_id}"
      return if category_id == 0
      Tegu.ListingTrack.track_category_view(category_id)
  catch e
