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

    def default_lives_warning(initial_lives)
      @output.puts "Invalid number of initial lives; reset to #{ initial_lives }"
    end

    def invalid_word_error
      @error.puts 'Game cannot start, the word you have entered is invalid.'
    end

    def confirm_start_game
      @output.print 'Would you like to play a game? (y/n): '

      choice = get_user_input

      YES.include? choice
    end

    def show_game_state(word, lives_remaining, guess_matched = nil)
      masked_word = word.map { |letter| letter || PLACEHOLDER }

      @output.puts "Your last guess #{ guess_matched ? 'uncovered a letter' : 'did not match anything'}" unless guess_matched.nil?
      @output.puts
      @output.puts "The word looks like #{ masked_word.join(' ') }"
      @output.puts "You have #{ lives_remaining } lives remaining"
    end

    def get_guess
      @output.print "Please enter your guess: "
      get_user_input
    end

    def invalid_guess_warning(invalid_guess)
      @output.puts "'#{ invalid_guess.nil? ? 'nil' : invalid_guess }' is not a valid guess."
    end

    def game_won(word, guesses_required, lives_remaining)
      @output.puts "Congratulations! You have correctly guessed #{ word } in #{ guesses_required } guesses."
      @output.puts "You still had #{lives_remaining} lives remaining."
    end

    def game_lost(word, guesses_used, lives)
      @output.puts "You appear to have run out of lives. The word was #{ word }."
      @output.puts "You made #{ guesses_used } guesses and #{ lives } were incorrect."
    end

    private

    def get_user_input
      user_input = @input.gets || EMPTY_RESPONSE
      user_input.chomp.downcase
    end
  end
end
