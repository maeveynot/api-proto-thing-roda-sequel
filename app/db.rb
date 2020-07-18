require 'logger'
require 'sequel/core'
require_relative 'lib/helpers/env'

begin
  DB = Sequel.connect(ENV_delete_in_prod('PLUM_DATABASE_URL'))
rescue Sequel::DatabaseConnectionError => e
  $stderr.puts e.message
  sleep 1
  $stderr.puts "Retrying connection..."
  retry
end

DB.loggers << Logger.new($stderr).tap do |logger|
  logger.level = Logger::FATAL unless ENV['RACK_ENV'] == 'production'
end
