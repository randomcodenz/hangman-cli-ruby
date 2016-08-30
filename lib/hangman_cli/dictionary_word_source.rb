module HangmanCLI
  class DictionaryWordSource
    DICTIONARY_PATH = '/usr/share/dict/words'

    def initialize(min_word_length = 5, max_word_length = 15)
      @min_word_length = min_word_length || 0
      @max_word_length = max_word_length || 256
    end

    def get_word
      File.open(DICTIONARY_PATH) do |dictionary|
        dictionary
          .readlines
          .select { |word| word.length.between?(@min_word_length, @max_word_length) }
          .sample
          .chomp
      end
    end
  end
end
