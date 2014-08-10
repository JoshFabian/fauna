$(document).ready ->

  $(document).on 'click', "a.user-store-category", (e) ->
    e.preventDefault()
    category_id = $(this).data('category-id')
    store_path = $(this).attr('href')
    console.log "user store category:#{store_path} ..."
    async.waterfall [
      (callback) ->
        # get stories
        Tegu.UserStoreView.get_store_by_category(store_path, auth_token, callback)
      (data, callback) ->
        # console.log data
        # update store nav
        Tegu.UserStoreView.select_category(category_id)
        # update store listings
        Tegu.UserStoreView.init_listings(data)
    ]

  if $("form.user-store-search").length == -1
    $("form.user-store-search").validate
      onsubmit: true,
      submitHandler: (form) ->
        query = $(form).find("input[name=query]").val()
        store_path = $(form).attr('action')
        console.log "user store search:#{query} ..."
        async.waterfall [
          (callback) ->
            # get stories
            Tegu.UserStoreView.get_store_by_search(store_path, {query: query}, auth_token, callback)
          (data, callback) ->
            # console.log data
            # update store listings
            Tegu.UserStoreView.init_listings()
        ]