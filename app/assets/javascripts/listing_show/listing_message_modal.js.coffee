class Tegu.ListingMessageModal
  @close: () ->
    $('#listing-message-modal').foundation('reveal', 'close')

$(document).ready ->

  $("#listing-message-modal a.button").on 'click', (e) ->
    e.preventDefault()
    modal = $(this).closest('.reveal-modal')
    listing_id = $(modal).data('listing-id')
    user_id = $(modal).data('user-id')
    message_subject = $(modal).find('.message-subject').val()
    message_body = $(modal).find('.message-body').val()
    return if !message_subject or !message_body
    data = {message: {subject: message_subject, body: message_body}, listing: {id: listing_id}}
    console.log "user:#{user_id}, listing:#{listing_id} message ..."
    async.waterfall [
      (callback) ->
        # create conversation
        Tegu.MessageApi.create_conversation(user_id, data, auth_token, callback)
      (data, callback) ->
        console.log data
        Tegu.ListingMessageModal.close()
    ]
