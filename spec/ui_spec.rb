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

        it 'outputs the start game message' do
          expect(output.string).to match(UI::START_GAME)
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

      it 'outputs the invalid word error' do
        expect(error.string.chomp).to match(UI::INVALID_WORD_ERROR)
      end
    end

    describe '#default_lives_warning' do
      before { game.default_lives_warning }

      it 'outputs the default lives warning' do
        expect(output.string.chomp).to match(UI::DEFAULT_LIVES_WARNING)
      end
    end
  end
end
