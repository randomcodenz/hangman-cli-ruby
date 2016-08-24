module HangmanCLI
  class UI

    START_GAME = 'Would you like to play a game? (y/n): '

    def initialize( input, output, error )
      @input = input
      @output = output
      @error = error
    end

    def start_game?
      @output.print( START_GAME )

      @choice = @input.gets
      @choice &&= @choice.chomp.downcase

      @choice == 'y' ? true : false;
    end
  end
end
