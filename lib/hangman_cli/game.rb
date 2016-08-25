module HangmanCLI
  class Game
    DEFAULT_LIVES = 5
    MIN_LIVES = 1
    MAX_LIVES = 10
    VALID_WORD_PATTERN = /^[A-Za-z]+$/

    attr_reader :lives

    def initialize( ui, lives, word )
      @ui = ui
      @lives = lives
      @word = word
    end

    def start
      validate_lives!
      validate_word!

      run if valid_word? && @ui.confirm_start_game
    end

    private

    def validate_lives!
      valid_lives = @lives && lives.between?(MIN_LIVES, MAX_LIVES)

      if !valid_lives
        @lives = DEFAULT_LIVES
        @ui.default_lives_warning
      end
    end

    def validate_word!
      if !valid_word?
        @word = nil
        @ui.invalid_word_error
      end
    end

    def valid_word?
      @word && @word.match(VALID_WORD_PATTERN)
    end

    def run
      # game loop
    end
  end
end
