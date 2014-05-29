$(document).ready ->

  # click on upload button
  $(document).on "click", ".profile-avatar .upload-image", (e) ->
    # show file select dialog
    $(this).closest(".profile-avatar").find(".cloudinary-fileupload").trigger('click')

  # callback on file upload start
  $(document).on "fileuploadsend", '.profile-avatar .cloudinary-fileupload', (e, data) ->
    console.log "user avatar upload starting"

  # callback during file upload
  $(document).on "fileuploadprogress", '.profile-avatar .cloudinary-fileupload', (e, data) ->
    percent = Math.round((data.loaded * 100.0) / data.total)
    console.log "user avatar upload progress: #{percent}"

  # callback after file upload
  $(document).on "fileuploaddone", '.profile-avatar .cloudinary-fileupload', (e, data) ->
    console.log "user avatar upload completed"
    # save image params
    $(this).siblings(".avatar-image-params").val(JSON.stringify(data.result))
    # show uploaded image
    image_url = data.result.url
    preview_url = Tegu.CloudinaryHelper.transform(image_url, "w_100,h_100,c_fit")
    $(this).closest(".profile-avatar").find("img").attr('src', preview_url)
    $(this).closest(".profile-avatar").find(".upload-image").remove()


