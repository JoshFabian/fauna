$(document).ready ->

  $("a.listing-credits-add").on 'click', (e) ->
    e.preventDefault()
    user_id = $(this).data('user-id')
    async.waterfall [
      (callback) ->
        # add credits
        Tegu.UserApi.add_credits(user_id, auth_token, callback)
      (data, callback) ->
        # console.log data
        # reload page
        window.location.reload(true)
    ]

  $("#users").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#users tr.user" # selector for all items you'll retrieve
    loading: {
      img: 'data:image/gif;base64,R0lGODlhAQABAHAAACH5BAUAAAAALAAAAAABAAEAAAICRAEAOw=='
      msgText: "<span style='font-size: 0.7em;'>loading more ...<span>"
      finishedMsg: "<span style='font-size: 0.7em;'>no more users<span>"
    }
    debug: false
