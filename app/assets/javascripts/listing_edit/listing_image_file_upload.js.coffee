$(document).ready ->

  # click on upload button
  $(document).on "click", ".image-box.add .add-images-button", (e) ->
    e.preventDefault()
    return if !$(this).hasClass('editable')
    console.log "image upload click"
    # show file select dialog
    $(this).siblings(".cloudinary-fileupload").trigger('click')

  # callback when file upload starts
  $(document).on "fileuploadsend", '.image-box .cloudinary-fileupload', (e, data) ->
    listing_id = Tegu.ListingForm.get_listing_id()
    console.log "listing:#{listing_id} image upload starting"
    # jQuery.gritter.add({image: '/assets/success.png', title: 'List', text: 'Uploading', time: 500})

  # callback during file upload
  $(document).on "fileuploadprogress", '.image-box .cloudinary-fileupload', (e, data) ->
    percent = Math.round((data.loaded * 100.0) / data.total)
    listing_id = Tegu.ListingForm.get_listing_id()
    console.log "listing:#{listing_id} image upload progress: #{percent}"
    # update progress bar
    # $(this).siblings('.progress').show().css('width', percent + '%')

  # callback after file upload completes
  $(document).on "fileuploaddone", '.image-box .cloudinary-fileupload', (e, data) ->
    listing_id = Tegu.ListingForm.get_listing_id()
    console.log "listing:#{listing_id} image upload done ... v2"
    async.waterfall [
      (callback) ->
        # create new listing image
        Tegu.ListingApi.create_images(listing_id, {image_params: [data.result]}, auth_token, callback)
      (data, callback) ->
        # get images
        Tegu.ListingForm.get_images(listing_id, callback)
      (data, callback) ->
        # console.log data
        # replace images
        Tegu.ListingForm.replace_images(data)
        # init cloudinary
        Tegu.ListingForm.init_cloudinary()
    ]

  # deprecated: v1 - callback after file upload completes
  $(document).on "fileuploaddone", '.image-box.xxx .cloudinary-fileupload', (e, data) ->
    console.log "image upload done ... v1"
    # save image
    Tegu.ListingImage.new_image(data.result)
    # hide progress bar
    # $(this).siblings(".progress").hide()
    # get transformed image
    image_url = data.result.url
    preview_url = Tegu.CloudinaryHelper.transform(data.result.url, "c_fit,w_200,h_200")
    image_box = $(this).closest(".image-box")
    async.waterfall [
      (callback) ->
        # show image preview
        Tegu.ListingForm.show_image_preview(image_box, image_url, preview_url, data.result.width, data.result.height)
        # get new image partial
        Tegu.ListingForm.get_new_image(callback)
      (data, callback) ->
        # console.log data
        # replace empty image in document
        Tegu.ListingForm.replace_empty_image(data)
        # init cloudinary for newly added partial
        Tegu.ListingForm.init_cloudinary()
        # trigger image crop
        Tegu.ListingForm.trigger_image_crop()
    ]
    