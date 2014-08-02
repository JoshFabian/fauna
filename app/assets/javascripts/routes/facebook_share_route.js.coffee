class Tegu.FacebookShareRoute
  @auth_route: (klass, id, page) ->
    "/facebook/share/#{klass}/#{id}/auth/from/#{page}"
  