require 'logger'
require 'sequel/core'
require_relative 'lib/helpers/env'

DB = Sequel.connect(ENV_delete_in_prod('PLUM_DATABASE_URL'))

DB.loggers << Logger.new($stderr).tap do |logger|
  logger.level = Logger::FATAL unless ENV['RACK_ENV'] == 'production'
end
