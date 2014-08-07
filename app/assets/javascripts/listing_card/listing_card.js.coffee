class Tegu.ListingSlider
  @open: (push_url) ->
    translationValue = $(document).height() - $('#contentSlider').height() - 150
    $(document.body).addClass('no-scroll')
    $('#contentSlider').addClass('active')
    try
      history.pushState({}, '', push_url)
    catch e

  @close: () ->
    translationValue = $(document).height() - $('#contentSlider').height() - 150
    $(document.body).removeClass('no-scroll')
    $('#contentSlider').removeClass('active')
    try
      history.back()
    catch e

  @fill: (data) ->
    $(".slider-wrapper").find(".row").remove()
    $(".slider-wrapper").append(data)

  @get_listing: (user_handle, listing_id, token, callback) ->
    api = "/#{user_handle}/listings/#{listing_id}?token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

$(document).ready ->

  try
    $close = $("#closeButton")
    $window = $("#contentSlider")
    offset = $close.offset()
    topSpacing = 45
  catch e

  $(".listing-card-open").on 'click', (e) ->
    user_id = $(this).closest("li.listing").data('user-id')
    user_handle = null
    listing_id = $(this).closest("li.listing").data('listing-id')
    listing_slug = $(this).closest("li.listing").data('listing-slug')
    console.log "listing:#{listing_id} slider click ..."
    async.waterfall [
      (callback) ->
        # get user
        Tegu.UserApi.get(user_id, auth_token, callback)
      (data, callback) ->
        console.log data
        user_handle = data.user.handle
        # get user listing
        Tegu.ListingSlider.get_listing(user_handle, listing_id, auth_token, callback)
      (data, callback) ->
        # console.log data
        console.log "listing:#{listing_id} adding data ..."
        Tegu.ListingSlider.fill(data)
        console.log "listing:#{listing_id} init image slider ..."
        Tegu.ListingImageSlider.init()
        console.log "listing:#{listing_id} slider open ..."
        Tegu.ListingSlider.open("/#{user_handle}/listings/#{listing_slug}")
    ]

  $(document).on 'click', '#closeButton a', (e) ->
    Tegu.ListingSlider.close()

  $("#contentSlider").on 'scroll', () ->
    # console.log "listing slider scroll 1 ..."
    $close.stop().animate({top: $window.scrollTop() + topSpacing})

  # fix: this doesn't seem to work
  # $(document).on 'scroll', "#contentSlider", () ->
  #   console.log "listing slider scroll 2 ..."