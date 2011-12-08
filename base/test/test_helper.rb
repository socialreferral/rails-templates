require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'
  require 'mocha'

  class ActiveSupport::TestCase
    include Factory::Syntax::Methods

    # Add more helper methods to be used by all tests here...
  end
end

