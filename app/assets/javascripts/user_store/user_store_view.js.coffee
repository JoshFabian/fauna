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

  @unselect_categories: () ->
    $("a.user-store-category").removeClass('active')

  @init_listings: (data) ->
    $(".body-wrapper").find(".store-categories").remove()
    $(".body-wrapper").find(".store-search").remove()
    $(".body-wrapper").find(".store-listings").remove()
    $(".body-wrapper").append(data)

  @init_search_handler: () ->
    $("form.user-store-search").validate
      onsubmit: true,
      submitHandler: (form) ->
        query = $(form).find("input[name=query]").val()
        store_path = $(form).attr('action')
        console.log "user store search:#{query} ..."
        async.waterfall [
          (callback) ->
            # get store listings
            Tegu.UserStoreView.get_store_by_search(store_path, {query: query}, auth_token, callback)
          (data, callback) ->
            # console.log data
            # update store nav
            Tegu.UserStoreView.unselect_categories()
            # update store listings
            Tegu.UserStoreView.init_listings(data)
            # init search
            Tegu.UserStoreView.init_search_handler()
        ]

