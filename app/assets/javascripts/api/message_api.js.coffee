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