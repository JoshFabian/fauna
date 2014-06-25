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
