class Tegu.UserApi
  @get: (user_id, token, callback=null) ->
    api = "/api/v1/users/#{user_id}?token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @add_credits: (user_id, token, callback=null) ->
    api = "/api/v1/users/#{user_id}/credits/add/1?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @get_verified: (user_id, token, callback=null) ->
    api = "/api/v1/users/#{user_id}/verified?token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @update: (user_id, params, token, callback = null) ->
    api = "/api/v1/users/#{user_id}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @sort_cover_images: (user_id, params, token, callback = null) ->
    api = "/api/v1/users/#{user_id}/cover_images/sort?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback
