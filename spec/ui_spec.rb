require 'spec_helper'
require 'hangman_cli/ui'

module HangmanCLI
  describe UI do
    let(:input) { StringIO.new }
    let(:output) { StringIO.new }
    let(:error) { StringIO.new }

    subject(:game) { UI.new(input, output, error) }

    describe '#confirm_start_game' do
      context 'on every call' do
        before { game.confirm_start_game }

        it 'outputs a confirmation' do
          expect(output.string).not_to be_nil
        end
      end

      context 'when responding with nil' do
        # nil is implied as input.string has not been initialised
        it 'returns false' do
          expect(game.confirm_start_game).to eq false
        end
      end

      context 'when responding y' do
        before { input.string = 'y' }

        it 'returns true' do
          expect(game.confirm_start_game).to eq  true
        end
      end

      context 'when responding n' do
        before { input.string = 'n' }

        it 'returns false' do
          expect(game.confirm_start_game).to eq false
        end
      end

      context 'when responding yes' do
        before { input.string = 'yes' }

        it 'returns true' do
          expect(game.confirm_start_game).to eq true
        end
      end

      context 'when responding no' do
        before { input.string = 'no' }

        it 'returns false' do
          expect(game.confirm_start_game).to eq false
        end
      end

      context 'when responding with any other value' do
        before { input.string = 'WOPR' }

        it 'returns false' do
          expect(game.confirm_start_game).to eq false
        end
      end
    end

    describe '#invalid_word_error' do
      before { game.invalid_word_error }

      it 'outputs an error' do
        expect(error.string).not_to be_empty
        expect(output.string).to be_empty
      end
    end

    describe '#default_lives_warning' do
      before { game.default_lives_warning }

      it 'outputs a warning' do
        expect(output.string).not_to be_empty
        expect(error.string).to be_empty
      end
    end

    describe '#game_won' do
      let(:word) { 'Powershop' }
      let(:guesses_required) { 3 }

      before { game.game_won(word, guesses_required) }

      context 'the game won message' do
        it 'includes the word' do
          expect(output.string).to include(word)
        end

        it 'includes the guesses required' do
          expect(output.string).to include(guesses_required.to_s)
        end
      end
    end

    describe '#game_lost' do
      let(:word) { 'Powershop' }

      before { game.game_lost(word) }

      context 'the game lost message' do
        it 'includes the word' do
          expect(output.string).to include(word)
        end
      end
    end
  end
end
