require 'rack/test'
require 'refrigerator'
require_relative '../minitest_helper'
require_relative '../warnings_helper'
require_relative '../../app'

class Minitest::HooksSpec
  include Rack::Test::Methods

  def app
    Plum::API.app
  end
end

Refrigerator.freeze_core(except: %w[Object IO Struct Dir])
