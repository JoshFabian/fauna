class Tegu.ListingApi
  @create: (params, token, callback = null) ->
    api = "/api/v1/listings/?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @update: (id, params, token, callback = null) ->
    api = "/api/v1/listings/#{id}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

