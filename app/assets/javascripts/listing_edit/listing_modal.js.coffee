class Tegu.ListingModal
  @get_image_crop: (image_id, callback=null) ->
    $.ajax "/listing_modals/#{image_id}/image_crop.js",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

