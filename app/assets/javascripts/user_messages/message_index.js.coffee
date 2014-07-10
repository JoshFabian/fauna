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
        if conversation_id > 0
          console.log "init conversation: #{conversation_id}"
          $(".message-show[data-conversation-id=#{conversation_id}]").trigger 'click'
    ]

  $(document).on 'click', ".message-show", (e) ->
    e.preventDefault()
    conversation_id = $(this).data('conversation-id')
    console.log "conversation:#{conversation_id} show ..."
    async.waterfall [
      (callback) ->
        # get message
        Tegu.MessageView.get_conversation(current_user_handle, conversation_id, auth_token, callback)
      (data, callback) ->
        # console.log data
        Tegu.MessageView.show(data)
        # mark conversation as read
        Tegu.MessageApi.mark_as_read(conversation_id, auth_token, callback)
      (data, callback) ->
        # console.log data
        if data.user and data.user.id == current_user
          Tegu.MessageView.update_inbox_count(data.user.inbox_unread_count)
    ]
    