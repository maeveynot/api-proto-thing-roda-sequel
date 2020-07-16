require_relative 'spec_helper'

describe '/notes' do
  describe 'without authentication' do
    it 'cannot get notes' do
      get '/notes'
      assert_equal 401, last_response.status
    end
  end

  describe 'with authentication' do
    before do
      header 'Authorization', "Bearer #{Plum::Session.token}"
    end

    it 'can get notes' do
      get '/notes'
      assert_equal 200, last_response.status
    end

    describe 'creating a note' do
      before do
        @msg = 'Lorem ipsum dolor sit amet'
        post '/notes', { text: @msg }
      end

      it 'returns the supplied text' do
        resource = JSON.parse(last_response.body)
        assert_equal @msg, resource['text']
      end

      it 'shows up in the list of notes' do
        get '/notes'
        resource = JSON.parse(last_response.body)
        assert_kind_of Array, resource
        refute_empty resource
        assert resource.find {|n| n['text'] == @msg }
      end
    end

    it 'gets a correct error for a nonexistent note' do
      dummy = Note.create(text: 'Out, out, brief candle')
      id = dummy.id
      dummy.delete
      get "/notes/#{id}"
      assert_equal 404, last_response.status
    end
  end
end
