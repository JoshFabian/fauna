class Tegu.ListingForm
  @disable_form: () ->
    $("form.listing-edit input[type='submit']").addClass('disabled').attr('disabled', true).val("Saving ...")

  @enable_form: (s = "Saved") ->
    $("form.listing-edit input[type='submit']").removeClass('disabled').attr('disabled', false).val(s)

  @format_currency: () ->
    $("input.numeral").map ->
      try
        number = $(this).data('number')
        number = numeral(number/100).format('$0,0.00')
        $(this).val(number)
      catch

  @init_cloudinary: () ->
    for li in $(".image-grid li")
      # initialize cloudinary
      $(li).find("input.cloudinary-fileupload[type=file]").cloudinary_fileupload()

  @init_currency: () ->
    if $("input.numeral").length > 0
      Tegu.ListingForm.format_currency()

  @get_images: (listing_id, callback=null) ->
    $.ajax "/listing_forms/#{listing_id}/images.js",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @get_new_image: (callback=null) ->
    $.ajax "/listing_forms/new_image.js",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @get_shipping_table: (listing_id, shipping_from, callback=null) ->
    $.ajax "/listing_forms/#{listing_id}/shipping_table.js?shipping_from=#{shipping_from}",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @add_uploaded_image: (image_box, image_url, image_width, image_height) ->
    $(image_box).find("div:first").addClass('hide')
    $(image_box).append("<img src='#{image_url}'></img>")
    $(image_box).siblings('.dimensions').html("#{image_width} x #{image_height}")

  @replace_empty_image: (data) ->
    $(".image-grid li.empty:first").replaceWith(data)

  @replace_images: (data) ->
    $(".image-grid").html(data)
