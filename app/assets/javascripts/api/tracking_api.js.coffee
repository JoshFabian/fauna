class Tegu.TrackingApi
  @track_category_view: (category_id, session_token, token, callback = null) ->
    api = "/api/v1/track/categories/#{category_id}/view?session_token=#{session_token}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @track_listing_view: (listing_id, session_token, token, callback = null) ->
    api = "/api/v1/track/listings/#{listing_id}/view?session_token=#{session_token}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @track_user_profile_view: (user_id, session_token, token, callback = null) ->
    api = "/api/v1/track/users/#{user_id}/profile/view?session_token=#{session_token}&token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback
