require 'rack/unreloader'

if ENV['RACK_ENV'] == 'development'
  require 'logger'
  options = { subclasses: %w[Roda Sequel::Model], logger: Logger.new($stderr) }
  app = -> { Plum::API.app }
else
  options = { reload: false }
  app = -> { Plum::API.freeze.app }
end

Unreloader = Rack::Unreloader.new(options) { app.call }

Unreloader.require 'models.rb'
Unreloader.require('app.rb') { %w[Plum::API] }

if ENV['RACK_ENV'] == 'production'
  require 'refrigerator'
  Refrigerator.freeze_core(except: %w[Object IO Struct Dir])
end

run Unreloader
