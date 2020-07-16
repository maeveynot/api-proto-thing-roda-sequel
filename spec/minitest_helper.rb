require 'minitest/hooks/default'
require 'minitest/autorun'
require 'minitest/pride'

ENV['RACK_ENV'] = 'test'

class Minitest::HooksSpec
  around(:all) do |&block|
    DB.transaction(rollback: :always) do
      super(&block)
    end
  end
  around do |&block|
    DB.transaction(rollback: :always, savepoint: true, auto_savepoint: true) do
      super(&block)
    end
  end
end
