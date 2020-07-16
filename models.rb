require_relative 'db'
require 'sequel/model'

Sequel::Model.plugin :subclasses
Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :prepared_statements

unless defined?(Unreloader)
  require 'rack/unreloader'
  Unreloader = Rack::Unreloader.new(reload: false)
end

Unreloader.require 'models' do |f|
  Sequel::Model.send(:camelize, File.basename(f).sub(/\.rb\z/, ''))
end

if ENV['RACK_ENV'] == 'development'
  Sequel::Model.cache_associations = false
else
  Sequel::Model.freeze_descendents
  DB.freeze
end
