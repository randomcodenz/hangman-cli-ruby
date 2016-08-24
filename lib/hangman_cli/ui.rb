module HangmanCLI
  class UI

    START_GAME = 'Would you like to play a game? (y/n): '
    YES = [ 'y', 'yes' ]
    EMPTY_RESPONSE = ''

    def initialize( input, output, error )
      @input = input
      @output = output
      @error = error
    end

    def start_game?
      @output.print( START_GAME )

      @choice = @input.gets || EMPTY_RESPONSE
      @choice.chomp!
      @choice.downcase!

      # FIXME: I look like shit
      YES.any? { |yes| @choice == yes  }
    end
  end
end
