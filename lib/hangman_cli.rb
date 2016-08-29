require 'hangman_cli/version'
require 'hangman_cli/ui'
require 'hangman_cli/game'

module HangmanCLI
  def HangmanCLI.parse_options(args)
    options = { :lives => nil, :word => 'Powershop' }

    parser = OptionParser.new do |opts|
      opts.banner = 'Usage: hangman [options]'

      opts.on('-l', '--lives LIVES', 'Number of lives to start the game with') do |lives|
        options[:lives] = lives
      end

      opts.on('-w', '--word WORD', 'The word to be guessed') do |word|
        options[:word] = word
      end

      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end

    parser.parse(args)
    options
  end

  def HangmanCLI.play_hangman(input, output, error, options)
    ui = UI.new(input, output, error)
    game = Game.new(ui, options[:lives], options[:word])
    game.start
  end
end
