$(document).ready ->

  $("a.remove-button, a.mark-sold").on 'click', (e) ->
    e.preventDefault()
    listing_id = $(this).data('listing-id')
    console.log "listing:#{listing_id} marking as sold ..."
    async.waterfall [
      (callback) ->
        # update listing state
        Tegu.ListingApi.put_event(listing_id, 'sold', auth_token, callback)
      (data, callback) ->
        console.log data
        # reload page
        window.location.reload(true)
    ]