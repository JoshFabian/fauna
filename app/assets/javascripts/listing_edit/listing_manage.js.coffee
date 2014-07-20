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

  $("#listings").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#listings tr.listing" # selector for all items you'll retrieve
    loading: {
      img: 'data:image/gif;base64,R0lGODlhAQABAHAAACH5BAUAAAAALAAAAAABAAEAAAICRAEAOw=='
      msgText: "<span style='font-size: 0.7em;'>loading more ...<span>"
      finishedMsg: "<span style='font-size: 0.7em;'>no more listings<span>"
    }
    debug: false
