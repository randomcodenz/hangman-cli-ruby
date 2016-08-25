module HangmanCLI
  class UI

    START_GAME = 'Would you like to play a game? (y/n): '
    YES = [ 'y', 'yes' ]
    EMPTY_RESPONSE = ''
    DEFAULT_LIVES_WARNING = 'Invalid number of lives; reset to default'
    INVALID_WORD_ERROR = 'Game cannot start, the word you have entered is invalid.'

    def initialize(input, output, error)
      @input = input
      @output = output
      @error = error
    end

    def default_lives_warning
      @output.puts DEFAULT_LIVES_WARNING
    end

    def invalid_word_error
      @error.puts INVALID_WORD_ERROR
    end

    def confirm_start_game
      @output.print START_GAME

      choice = get_user_input

      YES.include? choice
    end

    def game_won(word, guesses_required)
      #TODO: Handle nil args?
      @output.puts "Congratulations! You have correctly guessed #{ word } in #{ guesses_required } guesses."
    end

    def game_lost(word)
      #TODO: handle nil args?
      @output.puts "You appear to have run out of lives. The word was #{ word }."
    end

    private

    def get_user_input
      user_input = @input.gets || EMPTY_RESPONSE
      user_input.chomp.downcase
    end
  end
end
