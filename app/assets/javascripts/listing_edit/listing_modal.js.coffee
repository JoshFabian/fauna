class Tegu.ListingModal
  @get_image_crop: (image_id, callback=null) ->
    $.ajax "/listing_modals/#{image_id}/image_crop.js",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @close_image_crop_modal: () ->
    $("#image-crop-modal").foundation('reveal', 'close')

  @show_image_crop_modal: (data) ->
    $("#image-crop-modal").html(data)
    $("#image-crop-modal").foundation('reveal', 'open')
