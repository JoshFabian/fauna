class Tegu.WaitlistApi
  @create: (params, token, callback = null) ->
    api = "/api/v1/waitlists/?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @update: (id, params, token, callback = null) ->
    api = "/api/v1/waitlists/#{id}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback
