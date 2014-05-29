$(document).ready ->

  # click on upload button
  $(document).on "click", ".cover-photo .upload-image", (e) ->
    # show file select dialog
    $(this).closest(".cover-photo").find(".cloudinary-fileupload").trigger('click')

  # callback on file upload start
  $(document).on "fileuploadsend", '.cover-photo .cloudinary-fileupload', (e, data) ->
    console.log "user cover upload starting"

  # callback during file upload
  $(document).on "fileuploadprogress", '.cover-photo .cloudinary-fileupload', (e, data) ->
    percent = Math.round((data.loaded * 100.0) / data.total)
    console.log "user cover upload progress: #{percent}"

  # callback after file upload
  $(document).on "fileuploaddone", '.cover-photo .cloudinary-fileupload', (e, data) ->
    console.log "user cover upload completed"
    # save image params
    $(this).closest(".cover-photo").find(".cover-image-params").val(JSON.stringify(data.result))
    # show uploaded image
    image_url = data.result.url
    preview_url = Tegu.CloudinaryHelper.transform(image_url, "w_100,h_100,c_fit")
    $(this).closest(".cover-photo").find("img").attr('src', preview_url)
    $(this).closest(".cover-photo").find(".upload-image").remove()


