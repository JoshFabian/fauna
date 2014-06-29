class Tegu.MessageView
  @get_conversation: (handle, label, conversation_id, token, callback=null) ->
    $.ajax "/#{handle}/messages/#{label}/#{conversation_id}?token=#{token}",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback
  
