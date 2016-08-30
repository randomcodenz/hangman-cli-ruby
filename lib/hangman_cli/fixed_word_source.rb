module HangmanCLI
  class FixedWordSource
    def initialize(word)
      @word = word
    end

    def get_word
      @word
    end
  end
end
