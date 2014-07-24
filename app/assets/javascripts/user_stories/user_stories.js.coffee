$(document).ready ->

  try
    if $(".status-panel").length > 0 and $(".update-panel").length == 0
      user_id = $(".status-panel").data('user-id')
      console.log "init user:#{user_id} stories ..."
      async.waterfall [
        (callback) ->
          # get stories
          Tegu.StoryView.get_stories(user_id, auth_token, callback)
        (data, callback) ->
          # console.log data
          Tegu.StoryView.prepend_stories(data)
      ]
  catch e