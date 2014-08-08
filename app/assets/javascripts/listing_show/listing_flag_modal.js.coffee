class Tegu.ListingFlagModal
  @open: (listing_id) ->
    $('#listing-flag-modal').find("#listing_id").val(listing_id)
    $('#listing-flag-modal').find("textarea").val("")
    $('#listing-flag-modal').foundation('reveal', 'open')

  @close: () ->
    $('#listing-flag-modal').foundation('reveal', 'close')

$(document).ready ->

  $(document).on 'click', '.listing-flag-modal-open', (e) ->
    e.preventDefault()
    listing_id = $(this).data('listing-id')
    console.log "listing:#{listing_id} flag modal open ..."
    Tegu.ListingFlagModal.open(listing_id)

  $(document).on 'click', "#listing-flag-modal a.button", (e) ->
    e.preventDefault()
    modal = $(this).closest('.reveal-modal')
    listing_id = $(modal).find("#listing_id").val()
    flag_reason = $(modal).find("textarea").val()
    return if !flag_reason
    console.log "listing:#{listing_id} flag ..."
    async.waterfall [
      (callback) ->
        # flag listing with reason
        Tegu.ListingApi.flag(listing_id, {reason: flag_reason}, auth_token, callback)
      (data, callback) ->
        console.log data
        # close modal
        Tegu.ListingFlagModal.close()
        # reload page
        window.location.reload(true)
    ]

