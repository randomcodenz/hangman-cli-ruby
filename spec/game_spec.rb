require 'spec_helper'
require 'hangman_cli/game'
require 'hangman_cli/ui'

LIVES = 5
WORD = 'Powershop'

shared_examples 'a game with invalid lives' do
  it 'resets lives to default' do
    expect(subject.lives).to eq HangmanCLI::Game::DEFAULT_LIVES
  end

  it 'warns the user' do
    expect(ui).to have_received(:default_lives_warning)
  end
end

describe HangmanCLI::Game do
  let(:ui) do
    instance_double( 'HangmanCLI::UI' ).tap do |ui|
      allow(ui).to receive(:default_lives_warning)
    end
  end

  context 'when starting an invalid game' do

    context 'with not enough lives' do
      subject { HangmanCLI::Game.new(ui, 0, WORD) }

      before { subject.start }

      it_should_behave_like 'a game with invalid lives'
    end

    context 'with too many lives' do
      subject{ HangmanCLI::Game.new(ui, 99, WORD) }

      before { subject.start }

      it_should_behave_like 'a game with invalid lives'
    end

    context 'with nil lives' do
      subject { HangmanCLI::Game.new(ui, nil, WORD) }

      before { subject.start }

      it_should_behave_like 'a game with invalid lives'
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
