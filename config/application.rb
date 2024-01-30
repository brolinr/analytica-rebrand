require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
module Analytica
  class Application < Rails::Application
    config.load_defaults 7.0

    config.i18n.load_path +=  Dir[Rails.root.join('config', 'locales', '*.yml')]
    config.i18n.available_locales = %i[en]
    config.i18n.default_locale = :en

    config.time_zone = "Harare"

    config.exceptions_app = self.routes
    
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
