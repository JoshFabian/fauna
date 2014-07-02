class Tegu.WelcomeModal
  @open: () ->
    $('#welcome-message-modal').foundation 'reveal', 'open'

  @close: () ->
    $('#welcome-message-modal').foundation 'reveal', 'close'

$(document).ready ->

  $(document).on 'closed', '[data-reveal]#welcome-message-modal', () ->
    console.log "user:#{current_user} welcome message seen"
    async.waterfall [
      (callback) ->
        # update user
        Tegu.UserApi.update(current_user, {user: {welcome_message: 1}}, auth_token, callback)
      (data, callback) ->
        # console.log data
    ]

  # for testing
  $("a.open-welcome-message-modal").on 'click', (e) ->
    e.preventDefault()
    Tegu.WelcomeModal.open()

  $(document).on 'foundation-initialized', (e) ->
    # console.log "foundation initialized"
    if current_user > 0 and welcome_message == 0
      setTimeout ( ->
        Tegu.WelcomeModal.open()
      ), 3000

