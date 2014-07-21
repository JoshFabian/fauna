$(document).ready ->

  # images

  $(".listing-images .image-grid li").on 'click', (e) ->
    e.preventDefault()
    return if $(this).hasClass('active')
    console.log "image load #{$(this).data('image-url')}"
    # remove active class
    $(".listing-images .image-grid li").removeClass('active')
    # add active class
    $(this).addClass('active')
    # replace image
    $(".listing-images .main-image img").attr('src', $(this).data('image-url'))

  if $(".listing-images .image-grid li").length > 0
    # console.log "init image carousel"
    $(".listing-images .image-grid li:first").trigger 'click'


  # pills

  $(".listing-images .pills .tab-title").on 'click', (e) ->
    e.preventDefault()
    pill = $(this).data('pill')
    console.log "pill:#{pill} click ..."
    # hide all pills
    $(".pills .tab-title").removeClass('active')
    $(".pills-content .content").addClass('hide')
    # mark active pill and show content
    $(this).addClass('active')
    $(".pills-content .content[id=#{pill}]").removeClass('hide')
