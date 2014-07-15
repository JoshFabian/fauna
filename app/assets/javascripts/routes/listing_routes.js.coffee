class Tegu.ListingRoutes
  @new_path: () ->
    "/listings/new"

  @show_path: (listing_id, token, callback) ->
    async.waterfall [
      (cb) ->
        Tegu.ListingApi.get(listing_id, token, cb)
      (data, cb) ->
        callback(null, "/listings/#{data.listing.slug}")
    ]
