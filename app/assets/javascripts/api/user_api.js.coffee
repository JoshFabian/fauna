class Tegu.UserApi
  @update: (user_id, params, token, callback = null) ->
    api = "/api/v1/users/#{user_id}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        if callback
          callback(null, data)
