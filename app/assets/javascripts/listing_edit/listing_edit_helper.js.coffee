$(document).ready ->

  textchange_timeout = 0
  $("#listing_title").bind 'textchange', (event, previousText) ->
    # console.log "previous:#{previousText}"
    clearTimeout(textchange_timeout)
    textchange_timeout = setTimeout () ->
      $("#listing_title").val(_.str.titleize($("#listing_title").val()))
    , 1500

  $("#listing_description").redactor({
    buttons: ['bold', 'italic', 'unorderedlist', 'orderedlist', 'link', 'horizontalrule']
  })

  $("input.numeral").on 'blur', (e) ->
    try
      if !$(this).val().match(/^\$/)
        # prepend $
        $(this).val("$#{$(this).val()}")
      if $(this).val().match(/^\$\d+$/)
        # append zeros
        $(this).val("#{$(this).val()}.00")
    catch e
