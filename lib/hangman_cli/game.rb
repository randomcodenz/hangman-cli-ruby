module HangmanCLI
  class Game

    DEFAULT_LIVES = 5
    MIN_LIVES = 1
    MAX_LIVES = 10
    VALID_WORD_PATTERN = /^[A-Za-z]+$/

    # TODO: Both of these only exist to support the tests ...
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

      default_initial_lives unless valid_lives
    end

    def default_initial_lives
      @initial_lives = DEFAULT_LIVES
      @ui.default_lives_warning
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
      @masked_word = @word.chars.map { |letter| nil }

      @ui.show_game_state(@masked_word, @lives_remaining)

      until game_over?
        guess = @ui.get_guess
        @guesses += 1

        # FIXME cause I am ugly
        guess_masked_word = @word.chars.map { |letter| letter.downcase == guess ? letter : nil }
        @masked_word = @masked_word.zip(guess_masked_word).map do |masked_pair|
          masked_pair.find { |letter| !letter.nil? }
        end

        @lives_remaining -= 1 unless guess && @word.downcase.include?(guess)

        @ui.show_game_state(@masked_word, @lives_remaining) unless game_over?
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
      @masked_word.none? { |letter| letter.nil? }
    end

    def show_game_over
      #TODO: Mutually exclusive actions yet code probably doesn't indicate that intent
      @ui.game_won(@word, @guesses, @lives_remaining) if game_won?
      @ui.game_lost(@word) if game_lost?
    end
  end
end
