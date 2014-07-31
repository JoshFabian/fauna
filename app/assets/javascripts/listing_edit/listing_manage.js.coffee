$(document).ready ->

  $("a.mark-flag").on 'click', (e) ->
    e.preventDefault()
    listing_id = $(this).data('listing-id')
    console.log "listing:#{listing_id} marking as flagged ..."
    async.waterfall [
      (callback) ->
        # update listing state
        Tegu.ListingApi.put_event(listing_id, 'flag', auth_token, callback)
      (data, callback) ->
        console.log data
        # reload page
        window.location.reload(true)
    ]

  $("a.mark-remove").on 'click', (e) ->
    e.preventDefault()
    listing_id = $(this).data('listing-id')
    console.log "listing:#{listing_id} marking as removed ..."
    async.waterfall [
      (callback) ->
        # update listing state
        Tegu.ListingApi.put_event(listing_id, 'remove', auth_token, callback)
      (data, callback) ->
        console.log data
        # reload page
        window.location.reload(true)
    ]

  $("a.mark-sold").on 'click', (e) ->
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

  $('a.listing-delete').bind 'ajax:success', (evt, data, status, xhr) ->
    console.log "listing deleted"
    # reload page
    window.location.reload(true)

  $("#listings_manage").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#listings_manage tr.listing" # selector for all items you'll retrieve
    loading: {
      img: 'data:image/gif;base64,R0lGODlhAQABAHAAACH5BAUAAAAALAAAAAABAAEAAAICRAEAOw=='
      msgText: "<div style='display: none; visibility: hidden;'>loading more ...</div>"
      finishedMsg: "<div style='font-size: 0.7em;'>no more<div>"
    }
    debug: false
