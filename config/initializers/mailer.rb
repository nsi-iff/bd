config_file = File.join(::Rails.root, 'config', 'mail.yml')
mail = File.exists?(config_file) ? YAML.load(File.read(config_file))[Rails.env] : {}

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.delivery_method = :test if Rails.env.test? || Rails.env.development?
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => mail['enable_starttls_auto'],
  :address        => mail['address'],
  :port           => mail['port'].to_i,
  :domain         => mail['domain'],
}
