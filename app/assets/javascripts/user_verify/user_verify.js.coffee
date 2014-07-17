$(document).ready ->

  $("a.user-verify-continue").on 'click', (e) ->
    e.preventDefault()
    url = $(this).attr('href')
    async.waterfall [
      (callback) ->
        # check if user is verified
        Tegu.UserApi.get_verified(current_user, auth_token, callback)
      (data, callback) ->
        # console.log data
        if data.user.verified
          # console.log "user verified ... redirect to #{url}"
          window.location.href = url
    ],
    # optional callback
    (err, results) ->
    