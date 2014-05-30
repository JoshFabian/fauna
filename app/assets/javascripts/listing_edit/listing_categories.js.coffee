class Tegu.ListingCategory
  @get_subcategories: (id, callback=null) ->
    $.ajax "/listing_forms/subcategories.js?id=#{id}",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @set_subcategories: (data) ->
    $(".category-wrapper[data-category-level=2]").html(data)

$(document).ready ->

  $(".category-wrapper").on 'change', (e, state) ->
    id = Number($(this).find("option:selected").val())
    name = $(this).find("option:selected").text()
    level = $(this).data('category-level')
    return if level != 1 or id == 0
    console.log "category:id:#{id}:name:#{name}"
    async.waterfall [
      (callback) ->
        # get subcategories
        Tegu.ListingCategory.get_subcategories(id, callback)
      (data, callback) ->
        # set subcategories
        Tegu.ListingCategory.set_subcategories(data)
    ]
