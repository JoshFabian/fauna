class Tegu.PostApi
  @create: (params, token, callback = null) ->
    api = "/api/v1/posts/?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback

  @create_comment: (post_id, params, token, callback = null) ->
    api = "/api/v1/posts/#{post_id}/comments?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params,
      success: (data) ->
        callback(null, data) if callback