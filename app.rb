require 'rack/ssl-enforcer'
require 'rack/jwt'
require 'roda'
require_relative 'models'
require_relative 'lib/patches'
require_relative 'lib/session'

module Plum
  class API < Roda
    opts[:check_dynamic_arity] = false
    opts[:check_arity] = :warn

    plugin :common_logger unless ENV['RACK_ENV'] == 'test'

    use Rack::SslEnforcer,
      :hsts => true,
      :except_environments => %w[development test]

    use Rack::JWT::Auth,
      secret: Plum::Session.secret,
      options: { algorithm: Plum::Session::ALGORITHM },
      exclude: [ /^\/$/, '/about' ]

    plugin :all_verbs
    plugin :json, classes: [Array, Hash, Sequel::Model]
    plugin :json_parser
    plugin :default_headers, 'Content-Type' => 'application/json'
    plugin :default_headers, 'X-Content-Type-Options' => 'nosniff'

    plugin :hash_routes
    Unreloader.require 'routes'
    route {|r| r.hash_routes }

    plugin :not_found do
      { error: "Not Found" }
    end

    plugin :error_handler do |e|
      $stderr.puts "#{e.class}: #{e.message}", e.backtrace
      if ENV['RACK_ENV'] == 'development'
        { error: e.class, message: e.message, backtrace: e.backtrace }
      else
        { error: "Internal Server Error" }
      end
    end
  end
end
