require 'spec_helper'
require 'hangman_cli/game'
require 'hangman_cli/ui'

module HangmanCLI
  #REVIEW: Can these be moved to the bottom of the file?
  shared_examples 'a game with invalid initial lives' do
    it 'notifies the user that the lives have been reset to the default value' do
      expect(ui).to have_received(:default_lives_warning).with(Game::DEFAULT_LIVES)
    end

    it 'confirms the user wants to start the game' do
      expect(ui).to have_received(:confirm_start_game)
    end
  end

  shared_examples 'a game with an invalid word' do
    it 'notifies the user that the word is invalid' do
      expect(ui).to have_received(:invalid_word_error)
    end

    it 'does not start a game' do
      expect(ui).not_to have_received(:confirm_start_game)
    end
  end

  #REVIEW: Parameters vs lets vs ??
  shared_examples 'a won game' do |bad_guess_count|
    it 'does not show the game state after the final guess' do
      expect(ui).not_to have_received(:show_game_state).with(word.chars, initial_lives - bad_guess_count)
    end

    it 'notifies the user the game is won and includes guesses_required and lives remaining' do
      expect(ui).to have_received(:game_won).with(word, guesses_required, initial_lives - bad_guess_count)
    end
  end

  shared_examples 'a lost game' do
    it 'does not show the game state after the final guess' do
      expect(ui).not_to have_received(:show_game_state).with(word.chars, 0)
    end

    it 'notifies the user the game is lost and includes guesses used and lives lost' do
      expect(ui).to have_received(:game_lost).with(word, guesses_required, initial_lives)
    end
  end

  describe Game do
    context 'when starting a game with invalid initial lives' do
      let(:ui) { instance_double(UI, :default_lives_warning => nil, :confirm_start_game => false) }

      subject(:game) { Game.new(ui, initial_lives, 'Powershop') }

      context 'and lives < 1' do
        let(:initial_lives) { 0 }

        before { subject.start }

        it_behaves_like 'a game with invalid initial lives'
      end

      context 'and lives > 10' do
        let(:initial_lives) { 99 }

        before { subject.start }

        it_behaves_like 'a game with invalid initial lives'
      end

      context 'and lives is nil' do
        let(:initial_lives) { nil }

        before { subject.start }

        it_behaves_like 'a game with invalid initial lives'
      end
    end

    context 'when starting a game with an invalid word' do
      # confirm_start_game => nil because it should never be called (this is expected in the shared example)
      let(:ui) { instance_double(UI, :invalid_word_error => nil, :confirm_start_game => nil) }

      subject { Game.new(ui, 5, word) }

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
      let(:guesses) { ['x'] }
      let(:guesses_required) { guesses.reject(&:nil?).length }
      #FIXME Too many allows - how to do this cleaner
      let(:ui) do
        ui = instance_double(UI,
          :confirm_start_game => true,
          :show_game_state => nil,
          :invalid_guess_warning => nil,
          :game_won => nil,
          :game_lost => nil)
        allow(ui).to receive(:get_guess).and_return(*guesses)
        ui
      end

      subject(:game) { Game.new(ui, initial_lives, word) }

      before { game.start }

      context 'and only 1 life' do
        let(:initial_lives) { 1 }

        it 'confirms the users wants to start the game' do
          expect(ui).to have_received(:confirm_start_game)
        end

        it 'shows the user the initial game state' do
          expect(ui).to have_received(:show_game_state).with([nil], initial_lives)
        end

        it 'requests a guess from the user' do
          expect(ui).to have_received(:get_guess)
        end

        context 'and the guess is correct' do
          let(:guesses) { ['p'] }

          it_behaves_like 'a won game', 0
        end

        context 'and the guess is incorrect' do
          let(:guesses) { ['z'] }

          it_behaves_like 'a lost game'
        end
      end

      context 'and 2 lives' do
        let(:initial_lives) { 2 }

        context 'and the first guess is correct' do
          let(:guesses) { ['p'] }

          it_behaves_like 'a won game', 0
        end

        context 'and the final guess is correct' do
          let(:guesses) { ['z', 'p'] }

          it 'decrements the lives remaining and indicates the guess was incorrect' do
            expect(ui).to have_received(:show_game_state).with(anything, 1, false)
          end

          it_behaves_like 'a won game', 1
        end

        context 'and the final guess is incorrect' do
          let(:guesses) { ['z', 'x'] }

          it 'decrements the lives remaining and indicates the guess was incorrect' do
            expect(ui).to have_received(:show_game_state).with([nil], 1, false)
          end

          it_behaves_like 'a lost game'
        end

        context 'and the first guess is invalid but the final guess is correct' do
          let(:guesses) { ['1', 'p'] }
          # The invalid guess does not count as a guess
          let(:guesses_required) { 1 }

          it 'does not decrement the lives remaining or provide guess feedback after the invalid guess' do
            expect(ui).to have_received(:show_game_state).with([nil], initial_lives, nil)
          end

          it_behaves_like 'a won game', 0
        end
      end
    end

    context 'when playing a game with a 2 letter word and 2 lives' do
      let(:initial_lives) { 2 }
      let(:word) { 'It' }
      let(:guesses) { [] }
      let(:guesses_required) { guesses.length }
      let(:ui) do
        ui = instance_double(UI,
          :confirm_start_game => true,
          :show_game_state => nil,
          :invalid_guess_warning => nil,
          :game_won => nil,
          :game_lost => nil)
        allow(ui).to receive(:get_guess).and_return(*guesses)
        ui
      end

      subject(:game) { Game.new(ui, initial_lives, word) }

      before { game.start }

      context 'and none of the letters are guessed correctly' do
        let(:guesses) { ['e', 'x'] }

        it 'decrements lives remaining and indicates an incorrect guess in response to the first guess' do
          expect(ui).to have_received(:show_game_state).with([nil, nil], 1, false)
        end

        it_behaves_like 'a lost game'
      end

      context 'and 1 of the letters are guessed correctly' do
        let(:guesses) { ['i', 'e', 's'] }

        it 'does not decrement lives remaining and indicates a correct guess in response to the correct guess' do
          expect(ui).to have_received(:show_game_state).with(['I', nil], initial_lives, true)
        end

        it 'decrements lives remaining and indicates an incorrect guess in response to the incorrect guess' do
          expect(ui).to have_received(:show_game_state).with(['I', nil], 1, false)
        end

        it_behaves_like 'a lost game'
      end

      context 'and all of the letters are guess correctly' do
        let(:guesses) { ['i', 't'] }

        it 'does not decrements lives remaining and indicates a correct guess in response to the first guess' do
          expect(ui).to have_received(:show_game_state).with(['I', nil], initial_lives, true)
        end

        it_behaves_like 'a won game', 0
      end
    end
  end
end
