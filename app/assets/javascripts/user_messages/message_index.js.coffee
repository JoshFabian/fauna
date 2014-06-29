$(document).ready ->

  $(document).on 'click', ".message-sidebar .message-label", (e) ->
    e.preventDefault()
    label = $(this).data('label')
    console.log "message label:#{label} ..."
    async.waterfall [
      (callback) ->
        # get conversations
        Tegu.MessageView.get_conversations(current_user_handle, label, auth_token, callback)
      (data, callback) ->
        # console.log data
        Tegu.MessageView.select_label(label)
        Tegu.MessageView.show(data)
    ]

  if $(".message-list.empty").length > 0
    label = $(".message-list.empty").data('label')
    console.log "init message list: #{label}..."
    async.waterfall [
      (callback) ->
        # get conversations
        Tegu.MessageView.get_conversations(current_user_handle, label, auth_token, callback)
      (data, callback) ->
        # console.log data
        Tegu.MessageView.select_label(label)
        Tegu.MessageView.show(data)
    ]

  $(document).on 'click', ".message-show", (e) ->
    e.preventDefault()
    label = $(this).data('label')
    conversation_id = $(this).data('conversation-id')
    console.log "conversation:#{conversation_id} show ..."
    async.waterfall [
      (callback) ->
        # get message
        Tegu.MessageView.get_conversation(current_user_handle, label, conversation_id, auth_token, callback)
      (data, callback) ->
        # console.log data
        Tegu.MessageView.show(data)
    ]

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
        # reload page
        window.location.reload(true)
    ]
