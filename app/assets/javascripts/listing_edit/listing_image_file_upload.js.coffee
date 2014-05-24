$(document).ready ->

  # click on upload button
  $(document).on "click", ".image-box.add .add-images-button", (e) ->
    e.preventDefault()
    console.log "image upload click"
    # show file select dialog
    $(this).siblings(".cloudinary-fileupload").trigger('click')

  # callback when file upload starts
  $(document).on "fileuploadsend", '.image-box .cloudinary-fileupload', (e, data) ->
    console.log "image upload starting"
    # jQuery.gritter.add({image: '/assets/success.png', title: 'List', text: 'Uploading', time: 500})

  # callback during file upload
  $(document).on "fileuploadprogress", '.image-box .cloudinary-fileupload', (e, data) ->
    percent = Math.round((data.loaded * 100.0) / data.total)
    console.log "image upload progress: #{percent}"
    # update progress bar
    # $(this).siblings('.progress').show().css('width', percent + '%')

  # callback after file upload completes
  $(document).on "fileuploaddone", '.image-box .cloudinary-fileupload', (e, data) ->
    console.log "image upload done"
    # save image params
    $(this).siblings(".image-params").val(JSON.stringify(data.result))
    # hide progress bar
    # $(this).siblings(".progress").hide()
    # show image preview
    image_url = Tegu.CloudinaryHelper.transform(data.result.url, "c_fit,w_200,h_200")
    image_box = $(this).closest(".image-box")
    # image_box.html("<img src='#{image_url}'></img>")
    async.waterfall [
      (callback) ->
        # get new image partial
        Tegu.ListingForm.get_new_image(callback)
      (data, callback) ->
        # console.log data
        # replace empty image in document
        $("li.empty:first").replaceWith(data)
        for li in $(".image-grid li")
          # initialize cloudinary
          $(li).find("input.cloudinary-fileupload[type=file]").cloudinary_fileupload()
    ]
    