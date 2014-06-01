require 'active_support/concern'

# patch lib/geokit-rails/geocoder_control.rb

module Geokit
  module GeocoderControl
    extend ActiveSupport::Concern
  
    def set_geokit_domain
      Geokit::Geocoders::domain = request.domain
    end

  end
end