class Tegu.ListingRoutes
  @new_path: () ->
    "/listings/new"

  @show_path: (listing_id, token, callback) ->
    "/lists/#{list_id}/edit"
