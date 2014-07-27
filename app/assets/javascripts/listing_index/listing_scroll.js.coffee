$(document).ready ->

  $("#listings").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#listings li.listing" # selector for all items you'll retrieve
    loading: {
      img: 'data:image/gif;base64,R0lGODlhAQABAHAAACH5BAUAAAAALAAAAAABAAEAAAICRAEAOw=='
      msgText: "<span style='font-size: 0.7em;'>loading more ...<span>"
      finishedMsg: "<span style='font-size: 0.7em;'>no more listings<span>"
    }
    debug: false
    , (new_elements) ->
      try
        listing_ids = ($(element).data('listing-id') for element in new_elements)
        console.log "track listing peek: #{listing_ids.join(',')}"
        Tegu.ListingTrack.track_listing_peeks(listing_ids)
      catch e