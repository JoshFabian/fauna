class Tegu.UserRole
  @is_admin: (roles) ->
    admin = roles.filter (s) -> s == 'admin'
    return admin.length == 1 ? true : false

  @is_guest: ->
    current_user == 0

  @is_owner: (user_id) ->
    user_id == current_user

  @is_user: ->
    current_user > 0

$(document).ready ->

  # console.log "roles: #{current_roles.join(',')}"
  # console.log "admin: #{Tegu.UserRole.is_admin(current_roles)}"

  # enable links if user is admin
  $(".admin.hide").each ->
    if Tegu.UserRole.is_admin(current_roles)
      $(this).removeClass('hide').show()
      # $(this).closest("div").show()

  # enable links if user is owner
  $(".edit.owner.hide, .delete.owner.hide").each ->
    if Tegu.UserRole.is_owner($(this).data('user-id'))
      $(this).removeClass('hide').show()
      # $(this).closest("div").show()