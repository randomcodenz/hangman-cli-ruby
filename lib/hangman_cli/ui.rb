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

    # Rename and extract the retrieval of the choice
    def start_game?
      @output.print START_GAME

      @choice = @input.gets || EMPTY_RESPONSE
      @choice.chomp!
      @choice.downcase!

      YES.include? @choice
    end
  end
end
