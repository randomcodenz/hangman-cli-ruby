require 'hangman_cli/version'
require 'hangman_cli/ui'
require 'hangman_cli/game'
require 'hangman_cli/dictionary_word_source'
require 'hangman_cli/fixed_word_source'

module HangmanCLI
  def HangmanCLI.parse_options(args)
    options = { :lives => nil, :word => nil, :use_dictionary => false }

    parser = OptionParser.new do |opts|
      opts.banner = "Usage:\n\thangman -w <word> [-l <lives>]\n\thangman -d [-l <lives>]\nOptions:"

      opts.on('-l', '--lives LIVES', 'Number of lives to start the game with') do |lives|
        options[:lives] = lives
      end

      opts.on('-w', '--word WORD', 'The word to be guessed (overrides -d)') do |word|
        options[:word] = word
        options[:use_dictionary] = false
      end

      opts.on('-d', '--dictionary', 'Use the system words file from /usr/share/dict/words') do
          options[:use_dictionary] = true unless options[:word]
      end

      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end

    begin
      parser.parse(args)

      unless options[:word] || options[:use_dictionary]
        raise OptionParser::MissingArgument.new('Must specify a word or use dictionary.')
      end

      options
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts $!.to_s
      puts parser
      exit
    end
  end

  def HangmanCLI.play_hangman(input, output, error, options)
    word_source = options[:word] ? FixedWordSource.new(options[:word]) : DictionaryWordSource.new
    ui = UI.new(input, output, error)
    game = Game.new(ui, options[:lives], word_source.get_word)
    game.start
  end
end
