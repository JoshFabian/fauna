require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "attachinary/orm/active_record"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Tegu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # add extensions
    config.autoload_paths += Dir[File.join(Rails.root, "app", "core_ext", "*.rb")].each {|l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, "lib", "*.rb")].each {|l| require l }

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = true

    config.active_record.observers = [:conversation_observer, :listing_observer, :review_observer, :waitlist_observer]

    config.generators do |g|
      g.test_framework :mini_test, :spec => true, :fixture => false
      g.helper false
      g.assets false
      g.view_specs false
    end

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        # location of your API
        resource '/api/*', :headers => :any, :methods => [:get, :post, :options, :put, :delete]
      end
    end
  end
end
