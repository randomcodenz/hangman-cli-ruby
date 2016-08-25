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

shared_examples 'a game with an invalid word' do
  it 'outputs the invalid word error' do
    expect(ui).to have_received(:invalid_word_error)
  end

  it 'ends the game' do
    #TODO: How can we test this?
    skip "How do we test the game has ended?"
  end
end

describe HangmanCLI::Game do
  context 'when starting a game with invalid lives' do
    let(:ui) do
      instance_double('HangmanCLI::UI').tap do |ui|
        allow(ui).to receive(:default_lives_warning)
      end
    end

    context 'and lives < 1' do
      subject { HangmanCLI::Game.new(ui, 0, WORD) }

      before { subject.start }

      it_should_behave_like 'a game with invalid lives'
    end

    context 'and lives > 10' do
      subject{ HangmanCLI::Game.new(ui, 99, WORD) }

      before { subject.start }

      it_should_behave_like 'a game with invalid lives'
    end

    context 'and lives is nil' do
      subject { HangmanCLI::Game.new(ui, nil, WORD) }

      before { subject.start }

      it_should_behave_like 'a game with invalid lives'
    end
  end

  context 'when starting a game with an invalid word' do
    let(:ui) do
      instance_double('HangmanCLI::UI').tap do |ui|
        allow(ui).to receive(:invalid_word_error)
      end
    end

    context 'and the word contains numbers' do
      subject { HangmanCLI::Game.new( ui, LIVES, '123467') }

      before { subject.start }

      it_should_behave_like 'a game with an invalid word'
    end

    context 'and the word is nil' do
      subject { HangmanCLI::Game.new( ui, LIVES, nil) }

      before { subject.start }

      it_should_behave_like 'a game with an invalid word'
    end

  end

  # Subject for a valid game
  #subject { HangmanCLI::Game.new( ui, LIVES, WORD )}


end
