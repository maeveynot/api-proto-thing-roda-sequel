require_relative 'spec_helper'

describe Note do
  describe 'with text' do
    it 'can be created' do
      msg = 'Lorem ipsum dolor sit amet'
      note = Note.create(text: msg)
      assert note
      assert_equal msg, note.text
    end
  end

  describe 'without text' do
    it 'cannot be created' do
      assert_raises Sequel::ValidationFailed do
        note = Note.create
      end
    end
  end
end
