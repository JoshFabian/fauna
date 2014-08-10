class Tegu.UserStoreView
  @get_store_by_category: (path, token, callback) ->
    api = "#{path}?token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @get_store_by_search: (path, params, token, callback) ->
    api = "#{path}?token=#{token}"
    $.ajax api,
      type: 'POST'
      dataType: 'html'
      data: params
      success: (data) ->
        callback(null, data) if callback

  @select_category: (category_id) ->
    $("a.user-store-category").removeClass('active')
    $("a.user-store-category[data-category-id=#{category_id}]").addClass('active')

  @init_listings: (data) ->
    $(".body-wrapper").find(".store-categories").remove()
    $(".body-wrapper").find(".store-search").remove()
    $(".body-wrapper").find(".store-listings").remove()
    $(".body-wrapper").append(data)


