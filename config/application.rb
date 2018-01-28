# Application configuration
require File.expand_path('../boot', __FILE__)

require 'rails/all'
# Ordinalize 14 - April - 15
require 'active_support/all'

# May 2017
# http://railscasts.com/episodes/362-exporting-csv-and-excel
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Gradcert
  # Revised January 2018
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    #    International
        config.i18n.default_locale = :en
        config.time_zone = 'Europe/Rome'

    #   Domestic - Brazil
#    config.i18n.default_locale = :pt_BR
#    config.time_zone = 'Brasilia'

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/model*.yml').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/definitions*.yml').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/sample*.yml').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/navbar*.yml').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/were_missing*.yml').to_s]

    config.action_mailer.delivery_method = :sendmail

    # DEPRECATION WARNING: Currently, Active Record suppresses errors raised within `after_rollback`/`after_commit` callbacks and only print them to the logs. In the next version, these errors will no longer be suppressed. Instead, the errors will propagate normally just like in other Active Record callbacks.
    # You can opt into the new behavior and remove this warning by setting:
    #  config.active_record.raise_in_transactional_callbacks = true
    # -->

    config.active_record.raise_in_transactional_callbacks = true

    # Zurb
    Bundler.require(:default, :assets, Rails.env)

    # DJ
    config.active_job.queue_adapter = :delayed_job
  end
end
