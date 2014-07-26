class Tegu.StoryScroll
  @init: () ->
    $(".user-feed .pagination").hide()
    $(".user-feed").infinitescroll {
      dataType: 'js'
      appendCallback: false
      navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
      nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
      itemSelector: ".user-feed .update-panel" # selector for all items you'll retrieve
      loading: {
        img: 'data:image/gif;base64,R0lGODlhAQABAHAAACH5BAUAAAAALAAAAAABAAEAAAICRAEAOw=='
        msgText: "<span style='font-size: 0.7em;'>loading more ...<span>"
        finishedMsg: "<span style='font-size: 0.7em;'>no more<span>"
      }
      debug: false
    }, (json, opts) ->
      if json
        Tegu.StoryScroll.append(json)
      else
        Tegu.StoryScroll.pause()

  @pause: () ->
    console.log "no more stories"
    $('.user-feed').infinitescroll('pause')
    # $('.user-feed').infinitescroll('unbind')

  @append: (json) ->
    $(".user-feed .update-panel:last").after(json)

$(document).ready ->

