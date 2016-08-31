module HangmanCLI
  class Game

    DEFAULT_LIVES = 5
    MIN_LIVES = 1
    MAX_LIVES = 10
    VALID_WORD_PATTERN = /^[A-Za-z]+$/
    VALID_GUESS_PATTERN = /^[A-Za-z]$/

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

      default_initial_lives unless valid_lives
    end

    def default_initial_lives
      @initial_lives = DEFAULT_LIVES
      @ui.default_lives_warning(@initial_lives)
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
      @guesses = []

      @ui.show_game_state(get_masked_word, get_lives_remaining)

      # TODO: Infinite loop if user keeps entering invalid letters - like nil
      until game_over?
        guess = @ui.get_guess

        update_game_state(guess)

        @ui.show_game_state(get_masked_word, get_lives_remaining) unless game_over?
      end

      show_game_over
    end

    def update_game_state(guess)
      guess.downcase! if guess
      if valid_guess?(guess)
        @guesses << guess unless @guesses.include? guess
      else
        @ui.invalid_guess_warning(guess)
      end
    end

    def get_lives_remaining
      bad_guesses = @guesses - @word.downcase.chars
      @initial_lives - bad_guesses.length
    end

    def valid_guess?(guess)
      return guess && guess =~ VALID_GUESS_PATTERN
    end

    def get_masked_word
      @word.chars.map { |letter| @guesses.include?(letter.downcase) ? letter : nil }
    end

    def game_over?
      lives_remaining = get_lives_remaining
      game_won?(lives_remaining) || game_lost?(lives_remaining)
    end

    def game_won?(lives_remaining)
      lives_remaining > 0 && word_guessed?
    end

    def game_lost?(lives_remaining)
      lives_remaining <= 0
    end

    def word_guessed?
      get_masked_word.none?(&:nil?)
    end

    def show_game_over
      lives_remaining = get_lives_remaining

      #TODO: Layout? if / elsif / else vs this as these 3 lines are mutually exclusive
      @ui.game_won(@word, @guesses.length, get_lives_remaining) if game_won?(lives_remaining)
      @ui.game_lost(@word, @guesses.length, @initial_lives) if game_lost?(lives_remaining)
      raise StandardError, "Something broke!" if game_won?(lives_remaining) && game_lost?(lives_remaining)
    end
  end
end
