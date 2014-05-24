class Tegu.CloudinaryHelper
  @transform: (url, transform) ->
    url.replace(/upload\/(.*)/, "upload/#{transform}/$1")
