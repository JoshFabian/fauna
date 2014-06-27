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
    # get transformed image
    image_url = Tegu.CloudinaryHelper.transform(data.result.url, "c_fit,w_200,h_200")
    image_box = $(this).closest(".image-box")
    async.waterfall [
      (callback) ->
        # show image preview
        Tegu.ListingForm.add_uploaded_image(image_box, image_url, data.result.width, data.result.height)
        # get new image partial
        Tegu.ListingForm.get_new_image(callback)
      (data, callback) ->
        # console.log data
        # replace empty image in document
        Tegu.ListingForm.replace_empty_image(data)
        # init cloudinary
        Tegu.ListingForm.init_cloudinary()
    ]
    