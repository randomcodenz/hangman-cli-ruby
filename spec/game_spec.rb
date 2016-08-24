require 'spec_helper'
require 'hangman_cli/game'
require 'hangman_cli/ui'

LIVES = 5
WORD = 'Powershop'

describe HangmanCLI::Game do
  let(:ui) { instance_double('UI') }

  context 'when starting an invalid game' do

    context 'with not enough lives' do
      it 'resets lives to default'
      it 'warns the user'
    end

    context 'with too many lives' do
      it 'resets lives to default'
      it 'warns the user'
    end

    context 'with nil lives' do
      it 'resets lives to default'
      it 'warns the user'
    end

    context 'with an invalid word' do
      it 'outputs the invalid word error'
      it 'ends the game'
    end

    context 'with nil word' do
      it 'outputs the invalid word error'
      it 'ends the game'
    end

  end

  # Subject for a valid game
  #subject { HangmanCLI::Game.new( ui, LIVES, WORD )}


end
