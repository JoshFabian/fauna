class Tegu.MessageView
  @get_conversations: (handle, label, token, callback=null) ->
    $.ajax "/#{handle}/messages/#{label}?token=#{token}",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @get_conversation: (handle, conversation_id, token, callback=null) ->
    $.ajax "/#{handle}/messages/#{conversation_id}?token=#{token}",
      type: 'GET'
      dataType: 'html'
      success: (data) ->
        callback(null, data) if callback

  @select_label: (label) ->
    $(".message-sidebar li").removeClass('active')
    $(".message-sidebar li[data-label=#{label}]").addClass('active')
  
  @show: (data) ->
    $(".message-list").replaceWith(data)

