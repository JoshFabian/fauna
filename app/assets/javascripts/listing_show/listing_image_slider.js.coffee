# royal slider plugin

class Tegu.ListingImageSlider
  @init: () ->
    for object in $('.listing-image-slider')
      $(object).royalSlider
        fullscreen: {
          enabled: true,
          nativeFS: true
        },
        controlNavigation: 'thumbnails',
        autoScaleSlider: true, 
        autoScaleSliderWidth: 970,     
        autoScaleSliderHeight: 860,
        loop: false,
        imageScaleMode: 'fit-if-smaller',
        navigateByClick: true,
        numImagesToPreload:2,
        arrowsNav:true,
        arrowsNavAutoHide: true,
        arrowsNavHideOnTouch: true,
        keyboardNavEnabled: true,
        fadeinLoadedSlide: true,
        globalCaption: false,
        globalCaptionInside: false,
        thumbs: {
          appendSpan: true,
          firstMargin: true,
          autoCenter: false,
          spacing: 5,
          paddingTop: 5,
          paddingBottom: 5,
        }