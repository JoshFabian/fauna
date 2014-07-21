class Tegu.ImageApi
  @update: (image_id, params, token, callback = null) ->
    api = "/api/v1/images/#{image_id}?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback
