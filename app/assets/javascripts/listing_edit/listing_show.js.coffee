$(document).ready ->

  $(".listing-images .image-grid li").on 'click', (e) ->
    e.preventDefault()
    return if $(this).hasClass('active')
    image_transform_url = Tegu.CloudinaryHelper.transform($(this).data('image-url'), $(this).data('transform'))
    console.log "image transform to #{image_transform_url}"
    # remove active class
    $(".listing-images .image-grid li").removeClass('active')
    # add active class
    $(this).addClass('active')
    # replace image
    $(".listing-images .main-image img").attr('src', image_transform_url)

  if $(".listing-images .image-grid li").length > 0
    # console.log "init image carousel"
    $(".listing-images .image-grid li:first").trigger 'click'