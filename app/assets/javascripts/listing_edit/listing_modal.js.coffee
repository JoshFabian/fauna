class Tegu.ListingModal
  @get_crop_modal: (image_id, image_url, callback=null) ->
    $.ajax "/listing_modals/crop_image.js?image_id=#{image_id}&image_url=#{image_url}",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @close_image_crop_modal: () ->
    $("#image-crop-modal").foundation('reveal', 'close')

  @show_image_crop_modal: (image_url) ->
    $("#image-crop-modal img").attr('src', image_url)
    $("#image-crop-modal").foundation('reveal', 'open')
