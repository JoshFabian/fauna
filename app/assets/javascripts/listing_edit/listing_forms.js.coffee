class Tegu.ListingForm
  @format_currency: () ->
    $("input.numeral").map ->
      try
        number = $(this).data('number')
        number = numeral(number/100).format('$0,0.00')
        $(this).val(number)
      catch
      
  @init_currency: () ->
    if $("input.numeral").length > 0
      Tegu.ListingForm.format_currency()

  @get_new_image: (callback=null) ->
    $.ajax "/listing_forms/new_image.js",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback