module HangmanCLI
  class Game
    DEFAULT_LIVES = 5
    MIN_LIVES = 1
    MAX_LIVES = 10
    VALID_WORD_PATTERN = /^[A-Za-z]+$/

    attr_reader :initial_lives, :lives_remaining

    def initialize( ui, initial_lives, word )
      @ui = ui
      @initial_lives = initial_lives
      @word = word
    end

    def start
      validate_initial_lives!
      validate_word!

      run if valid_word? && @ui.confirm_start_game
    end

    private

    def validate_initial_lives!
      valid_lives = @initial_lives && @initial_lives.between?(MIN_LIVES, MAX_LIVES)

      unless valid_lives
        @initial_lives = DEFAULT_LIVES
        @ui.default_lives_warning
      end
    end

    def validate_word!
      unless valid_word?
        @word = nil
        @ui.invalid_word_error
      end
    end

    def valid_word?
      @word && @word.match(VALID_WORD_PATTERN)
    end

    def run
      @guesses = 0
      @lives_remaining = @initial_lives

      until game_over?
        @ui.show_game_state([nil], @lives_remaining)
        guess = @ui.get_guess

        @guesses += 1
        @word_guessed = @word == guess

        @lives_remaining -= 1 unless word_guessed?
      end

      show_game_over
    end

    def game_over?
      game_won? || game_lost?
    end

    def game_won?
      @lives_remaining > 0 && word_guessed?
    end

    def game_lost?
      @lives_remaining <= 0
    end

    def word_guessed?
      @word_guessed
    end

    def show_game_over
      @ui.game_won(@word, @guesses, @lives_remaining) if game_won?
      @ui.game_lost(@word) if game_lost?
    end
  end
end
