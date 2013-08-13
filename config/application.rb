require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(:default, Rails.env)
end

module DigitalLibrary
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :'pt-BR'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.apache_log_file = '/var/log/apache2/access.log.1'

    # Configuracoes do acesso ao SAM
    config.sam_configuration = YAML.load(
      File.read(File.join(Rails.root, 'config', 'sam.yml')))[Rails.env].
      symbolize_keys

    # Configuracoes do acesso ao Cloudooo
    config.cloudooo_configuration = YAML.load(
      File.read(File.join(Rails.root, 'config', 'cloudooo.yml')))[Rails.env].
      symbolize_keys

    # Configuracoes de acesso ao elasticsearch
    config.elasticsearch_config = YAML.load(
      File.read(File.join(Rails.root, 'config', 'elasticsearch.yml')))[Rails.env]

    # Configuracoes de acesso ao nsi videogranulate
    config.videogranulate_configuration = YAML.load(
      File.read(File.join(Rails.root, 'config', 'videogranulate.yml')))[Rails.env].
      symbolize_keys

    config.mailer_configuration = YAML.load(File.read(
      File.join(Rails.root, 'config', 'mail.yml')))[Rails.env].symbolize_keys

    # configurações de itens nos portlets
    config.limite_de_itens_nos_portlets = 5
  end
end
