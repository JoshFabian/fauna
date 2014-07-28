class Tegu.ListingFlagModal
  @close: () ->
    $('#listing-flag-modal').foundation('reveal', 'close')

$(document).ready ->

  $("#listing-flag-modal a.button").on 'click', (e) ->
    e.preventDefault()
    modal = $(this).closest('.reveal-modal')
    listing_id = $(modal).data('listing-id')
    flag_reason = $(modal).find("textarea").val()
    console.log "listing:#{listing_id} flag ..."
    data = {reason: flag_reason}
    async.waterfall [
      (callback) ->
        # flag listing with reason
        Tegu.ListingApi.flag(listing_id, data, auth_token, callback)
      (data, callback) ->
        console.log data
        Tegu.ListingFlagModal.close()
    ]

