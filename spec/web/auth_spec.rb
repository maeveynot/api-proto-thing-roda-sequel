require_relative 'spec_helper'

describe 'auth' do
  describe 'with no token' do
    it 'is redirected from root' do
      get '/'
      assert_equal 302, last_response.status
    end

    it 'can get about' do
      get '/about'
      assert_equal 200, last_response.status
    end

    it 'cannot get something else' do
      get '/hello'
      assert_equal 401, last_response.status
    end
  end

  describe 'with a token' do
    before do
      header 'Authorization', "Bearer #{Plum::Session.token}"
    end

    it 'can get something else' do
      get '/hello'
      assert_equal 200, last_response.status
    end
  end
end
