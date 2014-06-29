$(document).ready ->

  $(document).on 'click', ".message-actions input", (e) ->
    # console.log "message action click"
    e.stopPropagation()

  $(document).on 'click', ".message-selector.select-all", (e) ->
    # console.log "message select all click"
    e.stopPropagation()
    if $(".message-selector.select-all input").prop('checked')
      # console.log "check all messages"
      for object in $(".message-list .message-actions input:checkbox")
        $(object).attr('checked', false)
        $(object).trigger('click')
    else
      # console.log "uncheck all messages"
      for object in $(".message-list .message-actions input:checkbox")
        $(object).attr('checked', false)

  $(document).on 'click', ".message-selector.delete", (e) ->
    e.preventDefault()
    conv_ids = ($(object).data('conversation-id') for object in $(".message-actions input:checked"))
    return if conv_ids.length == 0
    console.log "trash conversations:#{conv_ids.join(',')}"
    async.waterfall [
      (callback) ->
        # move conversations to trash
        Tegu.MessageApi.trash_conversations(conv_ids.join(','), auth_token, callback)
      (data, callback) ->
        console.log data
        # reload page
        window.location.reload(true)
    ]

  $(document).on 'click', ".message-selector.undelete", (e) ->
    e.preventDefault()
    conv_ids = ($(object).data('conversation-id') for object in $(".message-actions input:checked"))
    return if conv_ids.length == 0
    console.log "untrash conversations:#{conv_ids.join(',')}"
    async.waterfall [
      (callback) ->
        # move conversations to inbox
        Tegu.MessageApi.untrash_conversations(conv_ids.join(','), auth_token, callback)
      (data, callback) ->
        console.log data
        # reload page
        window.location.reload(true)
    ]
