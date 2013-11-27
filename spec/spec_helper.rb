require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'

# inicia simplecov (coverage) se não estiver usando spork, e com COVERAGE=true
if ENV["COVERAGE"]
  puts "Running Coverage Tool\n"
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails'
end

require 'rails/application'
require "bundler/setup"
require "tire"

# Depois dessa linha já é tarde demais. Now, load the rails stack
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'valid_attribute'
require 'cancan/matchers'
require 'rufus/scheduler'

unless ENV['INTEGRACAO_CLOUDOOO']
  require 'integration/fake_nsicloudooo'
end

ServiceRegistry.sam = NSISam::FakeClient.new unless ENV['INTEGRACAO_SAM']
ServiceRegistry.sam.expire = 5 if ENV['INTEGRACAO_SAM']

# ver http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
Devise.stretches = 1
Rails.logger.level = 4

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

require Rails.root + "db/criar_indices"

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include DigitalLibrary::SpecHelpers::Utils
  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods

  config.include(MailerMacros)
  config.before(:each) { resetar_emails }

  config.filter_run_excluding sam: true unless ENV['INTEGRACAO_SAM']

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  Capybara.javascript_driver = :poltergeist

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end

def page!
  save_and_open_page
end