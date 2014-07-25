class Tegu.StoryView
  @get_stories: (user_id, token, callback = null) ->
    api = "/stories?id=#{user_id}&token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @get_story: (story_id, story_klass, token, callback = null) ->
    api = "/stories/#{story_id}?klass=#{story_klass}&token=#{token}"
    $.ajax api,
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @replace_story: (story_klass, story_id, data) ->
    $(".update-panel#story_#{story_klass}_#{story_id}").replaceWith(data)

  @prepend_stories: (data) ->
    $(".user-feed .status-panel").after(data)

  @prepend_story: (data) ->
    $(".user-feed .status-panel").after(data)
    $(".user-feed .status-panel input,textarea").val('')
