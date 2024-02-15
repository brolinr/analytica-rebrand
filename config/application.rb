require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
module Analytica
  class Application < Rails::Application
    Rails.application.routes.default_url_options[:host] = ENV.fetch('HOST', "http://localhost:3000")

    config.load_defaults 7.0

    config.i18n.load_path +=  Dir[Rails.root.join('config', 'locales', '*.yml')]
    config.i18n.available_locales = %i[en]
    config.i18n.default_locale = :en

    config.time_zone = "Harare"

    config.exceptions_app = self.routes

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
