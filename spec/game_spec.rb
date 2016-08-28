require 'spec_helper'
require 'hangman_cli/game'
require 'hangman_cli/ui'

module HangmanCLI
  LIVES = 5
  WORD = 'Powershop'

  shared_examples 'a game with invalid initial lives' do
    it 'resets initial lives to default' do
      expect(subject.initial_lives).to eq Game::DEFAULT_LIVES
    end

    it 'displays the default lives warning' do
      expect(ui).to have_received(:default_lives_warning)
    end

    it 'starts the game' do
      expect(ui).to have_received(:confirm_start_game)
    end
  end

  shared_examples 'a game with an invalid word' do
    it 'displays the invalid word error' do
      expect(ui).to have_received(:invalid_word_error)
    end

    it 'does not start the game' do
      expect(ui).not_to have_received(:confirm_start_game)
    end
  end

  shared_examples 'a won game' do |guesses_required, bad_guesses|
    it 'displays game won' do
      expect(ui).to have_received(:game_won)
    end

    it 'displays the word' do
      expect(ui).to have_received(:game_won).with(word, anything, anything)
    end

    it 'displays the number of guesses required' do
      expect(ui).to have_received(:game_won).with(anything, guesses_required, anything)
    end
    it 'displays the number of lives remaining' do

      expect(ui).to have_received(:game_won).with(anything, anything, initial_lives-bad_guesses)
    end
  end

  shared_examples 'a lost game' do
    it 'displays game lost' do
      expect(ui).to have_received(:game_lost)
    end

    it 'displays the word' do
      expect(ui).to have_received(:game_lost).with(word)
    end

    it 'lives_remaining is 0' do
      expect(game.lives_remaining).to eq 0
    end
  end

  describe Game do
    context 'when starting a game with invalid initial lives' do
      let(:ui) { instance_double(UI, :default_lives_warning => nil, :confirm_start_game => false) }

      subject { Game.new(ui, lives, WORD) }

      context 'and lives < 1' do
        let(:lives) { 0 }

        before { subject.start }

        it_behaves_like 'a game with invalid initial lives'
      end

      context 'and lives > 10' do
        let(:lives) { 99 }

        before { subject.start }

        it_behaves_like 'a game with invalid initial lives'
      end

      context 'and lives is nil' do
        let(:lives) { nil }

        before { subject.start }

        it_behaves_like 'a game with invalid initial lives'
      end
    end

    context 'when starting a game with an invalid word' do
      # confirm_start_game => nil because it should never be called (this is expected in the shared example)
      let(:ui) { instance_double(UI, :invalid_word_error => nil, :confirm_start_game => nil) }

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

    context 'when playing a game with a 1 letter word' do
      let(:word) { 'p' }
      let(:guesses) { [nil] }
      #FIXME Too many allows - how to do this cleaner
      let(:ui) do
        ui = instance_double(UI)
        allow(ui).to receive_messages(
          :confirm_start_game => true,
          :show_game_state => nil,
          :game_won => nil,
          :game_lost => nil )
        allow(ui).to receive(:get_guess).and_return(*guesses)
        ui
      end

      subject(:game) { Game.new( ui, initial_lives, word )}

      before { game.start }

      context 'and only 1 life' do
        let(:initial_lives) { 1 }

        it 'confirms the user wants to play' do
          expect(ui).to have_received(:confirm_start_game)
        end

        it 'displays the current game state' do
          expect(ui).to have_received(:show_game_state).with([nil], initial_lives)
        end

        it 'prompts the user for a guess' do
          expect(ui).to have_received(:get_guess)
        end

        context 'and the guess is correct' do
          let(:guesses) { ['p'] }

          it_behaves_like 'a won game', 1, 0
        end

        context 'and the guess is incorrect' do
          let(:guesses) { ['z'] }

          it 'displays game lost' do
            expect(ui).to have_received(:game_lost)
          end

          it 'displays the word' do
            expect(ui).to have_received(:game_lost).with(word)
          end

          it 'lives_remaining is 0' do
            expect(game.lives_remaining).to eq 0
          end
        end
      end

      context 'and 2 lives' do
        let(:initial_lives) { 2 }

        context 'and the first guess is correct' do
          let(:guesses) { ['p']}

          it_behaves_like 'a won game', 1, 0
        end

        context 'and the final guess is correct' do
          let(:guesses) { ['z', 'p']}

          it 'displays the game state after the first guess' do
            expect(ui).to have_received(:show_game_state).with([nil], 1)
          end

          it_behaves_like 'a won game', 2, 1
        end

        context 'and the first guess is incorrect' do
          let(:guesses) { ['z']}

          it_behaves_like 'a lost game'
        end

        context 'and the final guess is incorrect' do
          let(:guesses) { ['z', 'x']}

          it 'displays the game state after the first guess' do
            expect(ui).to have_received(:show_game_state).with([nil], 1)
          end

          it_behaves_like 'a lost game'
        end
      end
    end
  end
end
