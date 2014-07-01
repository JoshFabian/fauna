$(document).ready ->

  $(".follow .follow-button").on 'click', (e) ->
    e.preventDefault()
    user_id = $(this).data('user-id')
    console.log "follow:#{user_id} ignored ..."