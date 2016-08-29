require 'hangman_cli/version'
require 'hangman_cli/ui'
require 'hangman_cli/game'

module HangmanCLI
  def HangmanCLI.play_hangman(input, output, error)
    ui = UI.new(input, output, error)
    game = Game.new(ui, 5, 'Powershop')
    game.start
  end
end
