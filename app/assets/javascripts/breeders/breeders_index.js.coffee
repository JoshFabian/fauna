$(document).ready ->

  $("#breeders").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#breeders li.breeder" # selector for all items you'll retrieve
    loading: {
      img: 'data:image/gif;base64,R0lGODlhAQABAHAAACH5BAUAAAAALAAAAAABAAEAAAICRAEAOw=='
      msgText: "<span style='font-size: 0.7em;'>loading more ...<span>"
      finishedMsg: "<span style='font-size: 0.7em;'>no more breeders<span>"
    }
    debug: false
