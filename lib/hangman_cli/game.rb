module HangmanCLI
  class Game
    DEFAULT_LIVES = 5
    MIN_LIVES = 1
    MAX_LIVES = 10
    VALID_WORD_PATTERN = /^[A-Za-z]+$/

    attr_reader :initial_lives

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

      if !valid_lives
        @initial_lives = DEFAULT_LIVES
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
      # set up game
      @lives_remaining = @initial_lives
      #  -
      # game loop
      #until game_over?
      #  output active game state
      #   - lives remaining
      #   - masked word
      #   - previous guesses
      #  get guess
      #  validate guess
      #  update game state
      #@lives_remaining -= 1
      #end

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
      # TODO: Implement me!
      false
    end

    def show_game_over
      guesses = @initial_lives - @lives_remaining
      @ui.game_won(@word, guesses) if game_won?
      
      @ui.game_lost(@word) if game_lost?
    end
  end
end
