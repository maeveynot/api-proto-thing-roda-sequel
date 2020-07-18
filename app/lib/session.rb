require 'rack/jwt'
require 'openssl'
require_relative 'helpers/env'

module Plum
  class Session
    ALGORITHM = 'RS256'

    def self.secret
      @secret ||= OpenSSL::PKey::RSA.new(ENV_delete_in_prod('PLUM_SESSION_KEY'))
    end

    def self.token
      Rack::JWT::Token.encode({ iat: Time.now.to_i }, secret, ALGORITHM)
    end
  end
end
