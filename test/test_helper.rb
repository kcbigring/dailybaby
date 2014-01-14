ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Dir[ "#{ Rails.root }/test/support/**/**.rb" ].each do | support_file |
  require support_file
end

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include DatabaseCleanerPlugin

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end
