require 'spec_helper'
require 'hangman_cli/ui'

describe HangmanCLI::UI do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  let(:error) { StringIO.new }

  subject { HangmanCLI::UI.new(input, output, error) }

  describe '#start_game?' do

    context 'on every call' do
      before { subject.start_game? }

      it 'outputs the start game message' do
        expect(output.string).to match(HangmanCLI::UI::START_GAME)
      end
    end

    context 'when responding with nil' do
      # nil is implied as input.string has not been initialised
      it 'returns false' do
        expect(subject.start_game?).to eq false
      end
    end

    context 'when responding y' do
      before { input.string = 'y' }

      it 'returns true' do
        expect(subject.start_game?).to eq  true
      end
    end

    context 'when responding n' do
      before { input.string = 'n' }

      it 'returns false' do
        expect(subject.start_game?).to eq false
      end
    end

    context 'when responding yes' do
      before { input.string = 'yes' }

      it 'returns true' do
        expect(subject.start_game?).to eq true
      end
    end

    context 'when responding no' do
      before { input.string = 'no' }

      it 'returns false' do
        expect(subject.start_game?).to eq false
      end
    end

    context 'when responding with any other value' do
      before { input.string = 'WOPR' }

      it 'returns false' do
        expect(subject.start_game?).to eq false
      end
    end

  end

  describe '#invalid_word_error' do
    before { subject.invalid_word_error }

    it 'outputs the invalid word error' do
      expect(error.string.chomp).to match(HangmanCLI::UI::INVALID_WORD_ERROR)
    end
  end

  describe '#default_lives_warning' do
    before { subject.default_lives_warning }

    it 'outputs the default lives warning' do
      expect(output.string.chomp).to match(HangmanCLI::UI::DEFAULT_LIVES_WARNING)
    end
  end
end
