$(document).ready ->

  $(".user-password-login-show").on 'click', (e) ->
    e.preventDefault()
    $(".user-password-login").removeClass('hide')
