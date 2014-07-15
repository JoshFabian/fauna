class Tegu.UserMessageModal
  @close: () ->
    $('#user-message-modal').foundation('reveal', 'close')

  @open: () ->
    $('#user-message-modal').foundation('reveal', 'open')

$(document).ready ->

  $("a.message-button").on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    return if current_user == 0
    Tegu.UserMessageModal.open()

  $("#user-message-modal a.button").on 'click', (e) ->
    e.preventDefault()
    modal = $(this).closest('.reveal-modal')
    user_id = $(modal).data('user-id')
    message_subject = $(modal).find('.message-subject').val()
    message_body = $(modal).find('.message-body').val()
    return if !message_subject or !message_body
    data = {message: {subject: message_subject, body: message_body}}
    console.log "user:#{user_id} message ..."
    async.waterfall [
      (callback) ->
        # create conversation
        Tegu.MessageApi.create_conversation(user_id, data, auth_token, callback)
      (data, callback) ->
        console.log data
        Tegu.UserMessageModal.close()
    ]
