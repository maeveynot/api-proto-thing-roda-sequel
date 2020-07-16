module Plum
  class API
    hash_path '/' do |r|
      r.redirect '/about'
    end

    hash_path '/about' do |r|
      { message: "Welcome!", docs: "https://plum.example/docs/api/v1" }
    end

    hash_path '/hello' do |r|
      {
        message: "Congrats! You authenticated successfully. Have a poem.",
        poem: {
          author: "Amy Lowell",
          title: "A London Thoroughfare. 2 A.M.",
          excerpt: [
            "Opposite my window,",
            "The moon cuts,",
            "Clear and round,",
            "Through the plum-coloured night.",
            "She cannot light the city;",
            "It is too bright.",
            "It has white lamps,",
            "And glitters coldly.",
          ]
        }
      }
    end
  end
end
