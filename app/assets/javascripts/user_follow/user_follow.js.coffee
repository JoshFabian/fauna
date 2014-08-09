class Tegu.UserFollow
  @update_follow_buttons: (data) ->
    try
      for follow in data.user.following
        do (follow) ->
          button = $(".follow-button[data-follow-id='#{follow.follow_id}']")
          if follow.follow_state == 'following'
            $(button).addClass('active').text("Unfollow")
          else
            $(button).removeClass('active').text("Follow")
    catch

  @handle_follow_event: (data) ->
    try
      follow_button = $(".follow-button[data-follow-id=#{data.user.follow_id}]")
      # follow_count = $(follow_button).next(".follow-count")
      console.log data.user
      if data.user.follow_event == 'follow'
        $(follow_button).addClass('active').text("Unfollow")
      else if data.user.follow_event == 'unfollow'
        $(follow_button).removeClass('active').text("Follow")
      # $(follow_count).text(data.user.follow_count)
    catch

  @toggle_follow_button: (follow_id) ->
    button = $(".follow-button[data-follow-id='#{follow_id}']")
    $(button).toggleClass('following')

$(document).ready ->

  $(document).on 'click', ".follow-button", (event) ->
    event.preventDefault()
    return if current_user == 0
    follow_id = $(this).data('follow-id')
    async.waterfall [
      (callback) ->
        # toggle following state
        # console.log("toggle following state: #{current_user}:#{follow_id}")
        Tegu.UserApi.toggle_follow_state(current_user, follow_id, auth_token, callback)
        # toggle follow button to give user immediate feedback
        Tegu.UserFollow.toggle_follow_button(follow_id)
      (data, callback) ->
        Tegu.UserFollow.handle_follow_event(data)
    ]

  if (".follow-button").length > 0 and current_user > 0
    follow_ids = []
    $(".follow-button").map ->
      follow_ids.push($(this).data('follow-id'))
    # console.log "follow_ids:#{follow_ids.join(',')}"
    return if follow_ids.length == 0
    async.waterfall [
      (callback) ->
        # get following state
        Tegu.UserApi.get_following_state(current_user, follow_ids, auth_token, callback)
      (data, callback) ->
        Tegu.UserFollow.update_follow_buttons(data)
    ]
