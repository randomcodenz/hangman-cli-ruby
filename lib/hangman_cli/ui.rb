module HangmanCLI
  class UI

    YES = [ 'y', 'yes' ]
    EMPTY_RESPONSE = ''
    PLACEHOLDER = '_'

    def initialize(input, output, error)
      @input = input
      @output = output
      @error = error
    end

    def default_lives_warning
      @output.puts 'Invalid number of lives; reset to default'
    end

    def invalid_word_error
      @error.puts 'Game cannot start, the word you have entered is invalid.'
    end

    def confirm_start_game
      @output.print 'Would you like to play a game? (y/n): '

      choice = get_user_input

      YES.include? choice
    end

    def show_game_state(word, lives_remaining)
      masked_word = word.collect { |letter| letter || PLACEHOLDER }
      @output.puts "The word looks like #{ masked_word.join(' ') }"
      @output.puts "You have #{ lives_remaining } lives remaining"
    end

    def get_guess
      @output.print "Please enter your guess: "
      get_user_input
    end

    def game_won(word, guesses_required, lives_remaining)
      #TODO: Handle nil args?
      @output.puts "Congratulations! You have correctly guessed #{ word } in #{ guesses_required } guesses."
      @output.puts "You still had #{lives_remaining} lives remaining."
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
