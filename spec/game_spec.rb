require 'spec_helper'
require 'hangman_cli/game'
require 'hangman_cli/ui'

module HangmanCLI
  LIVES = 5
  WORD = 'Powershop'

  shared_examples 'a game with invalid lives' do
    it 'resets lives to default' do
      expect(subject.lives).to eq Game::DEFAULT_LIVES
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

  describe Game do
    context 'when starting a game with invalid lives' do
      let(:ui) { instance_double(UI, :default_lives_warning => nil) }

      subject { Game.new(ui, lives, WORD) }

      context 'and lives < 1' do
        let(:lives) { 0 }

        before { subject.start }

        it_behaves_like 'a game with invalid lives'
      end

      context 'and lives > 10' do
        let(:lives) { 99 }

        before { subject.start }

        it_behaves_like 'a game with invalid lives'
      end

      context 'and lives is nil' do
        let(:lives) { nil }

        before { subject.start }

        it_behaves_like 'a game with invalid lives'
      end
    end

    context 'when starting a game with an invalid word' do
      let(:ui) { instance_double(UI, :invalid_word_error => nil) }

      subject { Game.new( ui, LIVES, word) }

      context 'and the word contains numbers' do
        let(:word) { 'P0wershop' }

        before { subject.start }

        it_behaves_like 'a game with an invalid word'
      end

      context 'and the word is nil' do
        let(:word) { nil }

        before { subject.start }

        it_behaves_like 'a game with an invalid word'
      end

    end
  end
end
