require 'spec_helper'
require 'hangman_cli/ui'

module HangmanCLI
  describe UI do
    let(:input) { StringIO.new }
    let(:output) { StringIO.new }
    let(:error) { StringIO.new }

    subject(:ui) { UI.new(input, output, error) }

    describe '#confirm_start_game' do
      let(:user_input) { nil }
      let(:ui_response) { ui.confirm_start_game }

      before { input.string = user_input if user_input }

      it 'outputs a confirmation' do
        expect(output.string).not_to be_nil
      end

      context 'when responding with nil' do
        # nil is implied as input.string has not been initialised
        it 'returns false' do
          expect(ui_response).to eq false
        end
      end

      context 'when responding y' do
        let(:user_input) { 'y' }

        it 'returns true' do
          expect(ui_response).to eq  true
        end
      end

      context 'when responding n' do
        let(:user_input) { 'n' }

        it 'returns false' do
          expect(ui_response).to eq false
        end
      end

      context 'when responding yes' do
        let(:user_input) { 'yes' }

        it 'returns true' do
          expect(ui_response).to eq true
        end
      end

      context 'when responding no' do
        let(:user_input) { 'no' }

        it 'returns false' do
          expect(ui_response).to eq false
        end
      end

      context 'when responding with any other value' do
        let(:user_input) { 'WOPR' }

        it 'returns false' do
          expect(ui_response).to eq false
        end
      end
    end

    describe '#invalid_word_error' do
      before { ui.invalid_word_error }

      it 'outputs an error' do
        expect(error.string).not_to be_empty
        expect(output.string).to be_empty
      end
    end

    describe '#default_lives_warning' do
      let(:lives) { 3 }

      before { ui.default_lives_warning(lives) }

      it 'outputs a warning' do
        expect(output.string).not_to be_empty
        expect(error.string).to be_empty
      end

      it 'the warning includes the new initial lives' do
        expect(output.string).to include(lives.to_s)
      end
    end

    describe '#invalid_guess_warning' do
      let(:invalid_guess) { 'bad guess' }

      before { ui.invalid_guess_warning(invalid_guess) }

      it 'outputs a warning' do
        expect(output.string).not_to be_empty
        expect(error.string).to be_empty
      end

      context 'when the invalid guess is nil' do
        let(:invalid_guess) { nil }

        it 'the warning includes the invalid guess' do
          expect(output.string).to include('nil')
        end
      end

      context 'when the invalid guess is not nil' do
        let(:invalid_guess) { '123' }

        it 'the warning includes the invalid guess' do
          expect(output.string).to include(invalid_guess)
        end
      end
    end

    describe '#game_won' do
      let(:word) { 'Powershop' }
      let(:guesses_required) { 3 }
      let(:lives_remaining) { 5 }

      before { ui.game_won(word, guesses_required, lives_remaining) }

      context 'the game won message' do
        it 'includes the word' do
          expect(output.string).to include(word)
        end

        it 'includes the guesses required' do
          expect(output.string).to include(guesses_required.to_s)
        end

        it 'includes the lives remaining' do
          expect(output.string).to include(lives_remaining.to_s)
        end
      end
    end

    describe '#game_lost' do
      let(:word) { 'Powershop' }
      let(:guesses_used) { 5 }
      let(:lives) { 3 }

      before { ui.game_lost(word, guesses_used, lives) }

      it 'the game lost message includes the word' do
        expect(output.string).to include(word)
      end

      it 'the game lost message includes the number of guesses taken' do
        expect(output.string).to include(guesses_used.to_s)
      end

      it 'the game lost message includes the number of lives used' do
        expect(output.string).to include(lives.to_s)
      end
    end

    describe '#show_game_state' do
      let(:word) { 'Powershop'.chars }
      let(:lives_remaining) { 2 }
      let(:guess_matched) { nil }

      before { ui.show_game_state(word, lives_remaining, guess_matched) }

      it 'renders the number of lives remaining' do
        expect(output.string).to include(lives_remaining.to_s)
      end

      it 'does not render the guess feedback' do
        expect(output.string).not_to include('Your last guess ')
      end

      context 'when there are no missing letters' do
        let(:word) { 'WOPR'.chars }

        it 'renders the word' do
          expect(output.string).to include('W O P R')
        end
      end

      context 'when there are some missing letters' do
        let(:word) { ['W', nil, 'P', 'R'] }

        it 'renders the masked word' do
          expect(output.string).to include('W _ P R')
        end
      end

      context 'when there are no letters' do
        let(:word) { [nil, nil, nil, nil] }

        it 'renders the masked word' do
          expect(output.string).to include('_ _ _ _')
        end
      end

      context 'when the last guess matched a letter' do
        let(:guess_matched) { true }

        it 'renders the guess matched feedback' do
          expect(output.string).to include('Your last guess uncovered a letter')
        end
      end

      context 'when the last guess did not match a letter' do
        let(:guess_matched) { false }

        it 'renders the guess did not match feedback' do
          expect(output.string).to include('Your last guess did not match anything')
        end
      end
    end
  end
end
