$(document).ready ->

  try
    if $(".user-bar .follow-button").length > 0
      user_id = $(".user-bar .follow-button:first").data('follow-id')
      console.log "track user view: #{user_id}"
      async.waterfall [
        (callback) ->
          Tegu.TrackingApi.track_user_profile_view(user_id, auth_token, callback)
        (data, callback) ->
          console.log data
      ]
  catch e