class Tegu.TrackingApi
  @track_category_view: (category_id, token, callback = null) ->
    api = "/api/v1/track/categories/#{category_id}/view?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @track_listing_view: (listing_id, token, callback = null) ->
    api = "/api/v1/track/listings/#{listing_id}/view?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback
