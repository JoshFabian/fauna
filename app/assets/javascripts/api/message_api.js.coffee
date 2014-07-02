class Tegu.MessageApi
  @read_conversations: (conversation_ids, token, callback = null) ->
    api = "/api/v1/conversations/#{conversation_ids}/read?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @trash_conversations: (conversation_ids, token, callback = null) ->
    api = "/api/v1/conversations/#{conversation_ids}/trash?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @untrash_conversations: (conversation_ids, token, callback = null) ->
    api = "/api/v1/conversations/#{conversation_ids}/untrash?token=#{token}"
    $.ajax api,
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        callback(null, data) if callback

  @create_conversation: (user_id, params, token, callback = null) ->
    api = "/api/v1/conversations/to/#{user_id}?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params
      success: (data) ->
        callback(null, data) if callback

  @reply_conversation: (conversation_id, params, token, callback = null) ->
    api = "/api/v1/conversations/#{conversation_id}/reply?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'json'
      data: params
      success: (data) ->
        callback(null, data) if callback

