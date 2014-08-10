$(document).ready ->

  $(document).on 'click', "a.user-store-category", (e) ->
    e.preventDefault()
    category_id = $(this).attr('category-id')
    store_path = $(this).attr('href')
    console.log "user store category:#{store_path} ..."
    async.waterfall [
      (callback) ->
        # get store listings
        Tegu.UserStoreView.get_store_by_category(store_path, auth_token, callback)
      (data, callback) ->
        # console.log data
        # update store nav
        Tegu.UserStoreView.select_category(category_id)
        # update store listings
        Tegu.UserStoreView.init_listings(data)
        # init search
        Tegu.UserStoreView.init_search_handler()
    ]

  if $("form.user-store-search").length > 0
    Tegu.UserStoreView.init_search_handler()
