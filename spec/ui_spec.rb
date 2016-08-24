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

      it 'outputs a welcome message' do
        expect(output.string).to match( HangmanCLI::UI::START_GAME )
      end
    end

    context 'when responding with nil' do
      # nil is implied as input.string has not been initialised
      it 'returns false' do
        expect( subject.start_game? ).to eq false
      end
    end

    context 'when responding y' do
      before { input.string = 'y' }

      it 'returns true' do
        expect( subject.start_game? ).to eq  true
      end
    end

    context 'when responding n' do
      before { input.string = 'n' }

      it 'returns false' do
        expect( subject.start_game? ).to eq false
      end
    end

    context 'when responding yes' do
      before { input.string = 'yes' }

      it 'returns true' do
        expect( subject.start_game? ).to eq true
      end
    end

    context 'when responding no' do
      before { input.string = 'no' }

      it 'returns false' do
        expect( subject.start_game? ).to eq false
      end
    end

    context 'when responding with any other value' do
      before { input.string = 'WOPR' }

      it 'returns false' do
        expect( subject.start_game? ).to eq false
      end
    end

  end
end
