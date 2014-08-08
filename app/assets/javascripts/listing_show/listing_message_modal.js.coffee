class Tegu.ListingMessageModal
  @open: (listing_id, user_id) ->
    $('#listing-message-modal').find("#listing_id").val(listing_id)
    $('#listing-message-modal').find("#user_id").val(user_id)
    $('#listing-message-modal').foundation('reveal', 'open')

  @close: () ->
    $('#listing-message-modal').foundation('reveal', 'close')

$(document).ready ->

  $(document).on 'click', '.listing-message-modal-open', (e) ->
    e.preventDefault()
    listing_id = $(this).data('listing-id')
    user_id = $(this).data('user-id')
    console.log "listing:#{listing_id} message modal open ..."
    Tegu.ListingMessageModal.open(listing_id, user_id)

  $(document).on 'click', "#listing-message-modal a.button", (e) ->
    e.preventDefault()
    modal = $(this).closest('.reveal-modal')
    listing_id = $(modal).find('#listing_id').val()
    user_id = $(modal).find('#user_id').val()
    message_subject = $(modal).find('.message-subject').val()
    message_body = $(modal).find('.message-body').val()
    return if !message_subject or !message_body
    data = {message: {subject: message_subject, body: message_body}, listing: {id: listing_id}}
    console.log "user:#{user_id}, listing:#{listing_id} send message ..."
    async.waterfall [
      (callback) ->
        # create conversation
        Tegu.MessageApi.create_conversation(user_id, data, auth_token, callback)
      (data, callback) ->
        console.log data
        Tegu.ListingMessageModal.close()
    ]
