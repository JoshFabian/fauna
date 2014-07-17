$(document).ready ->
  $(document).on 'click', ".message-reply .submit-message", (e) ->
    e.preventDefault()
    conversation_id = $(this).closest('.message-reply').data('conversation-id')
    message_body = $(this).closest('.message-reply').find("textarea.message-body").val()
    return if !message_body
    console.log "send reply: #{conversation_id}:#{message_body}"
    data = {message: {body: message_body}}
    async.waterfall [
      (callback) ->
        # send reply
        Tegu.MessageApi.reply_conversation(conversation_id, data, auth_token, callback)
      (data, callback) ->
        console.log data
        # get message
        Tegu.MessageView.get_conversation(current_user_slug, conversation_id, auth_token, callback)
      (data, callback) ->
        Tegu.MessageView.show(data)
    ]
