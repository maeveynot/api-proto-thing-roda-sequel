module Plum
  class API
    hash_branch 'notes' do |r|
      r.get true do
        Note.map(&:to_hash)
      end
      r.post true do
        Note.create(text: r.params['text']).to_hash
      end
      r.get Integer do |id|
        Note[id]&.to_hash
      end
    end
  end
end
