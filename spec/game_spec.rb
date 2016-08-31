require 'spec_helper'
require 'hangman_cli/game'
require 'hangman_cli/ui'

module HangmanCLI
  #REVIEW: Can these be moved to the bottom of the file?
  #REVIEW: Change language - not asserting display but rather ui has received the correct message
  shared_examples 'a game with invalid initial lives' do
    it 'sends default_lives_warning to ui' do
      expect(ui).to have_received(:default_lives_warning)
    end

    it 'includes the default lives value in the default_lives_warning message' do
      expect(ui).to have_received(:default_lives_warning).with(Game::DEFAULT_LIVES)
    end

    it 'sends confirm_start_game to ui' do
      expect(ui).to have_received(:confirm_start_game)
    end
  end

  shared_examples 'a game with an invalid word' do
    it 'sends invalid_word_error to ui' do
      expect(ui).to have_received(:invalid_word_error)
    end

    it 'does not send confirm_start_game to ui' do
      expect(ui).not_to have_received(:confirm_start_game)
    end
  end

  #REVIEW: Parameters vs lets vs ??
  shared_examples 'a won game' do |bad_guess_count|
    it 'does not send show_game_state after the final guess' do
      expect(ui).not_to have_received(:show_game_state).with(word.chars, initial_lives - bad_guess_count)
    end

    it 'sends game_won to ui' do
      expect(ui).to have_received(:game_won)
    end

    it 'includes the word in the game_won message' do
      expect(ui).to have_received(:game_won).with(word, anything, anything)
    end

    it 'includes the guesses required in the game won message' do
      expect(ui).to have_received(:game_won).with(anything, guesses_required, anything)
    end

    it 'includes lives remaining in the game_won message' do
      expect(ui).to have_received(:game_won).with(anything, anything, initial_lives - bad_guess_count)
    end
  end

  shared_examples 'a lost game' do
    it 'sends game_lost to the ui' do
      expect(ui).to have_received(:game_lost)
    end

    it 'includes the word in the game_lost message' do
      expect(ui).to have_received(:game_lost).with(word, anything, anything)
    end

    it 'includes the guesses taken in the game_lost message' do
      expect(ui).to have_received(:game_lost).with(anything, guesses_required, anything)
    end

    it 'includes the lives used in the game_lost message' do
      expect(ui).to have_received(:game_lost).with(anything, anything, initial_lives)
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

        it 'sends confirm_start_game to the ui' do
          expect(ui).to have_received(:confirm_start_game)
        end

        it 'sends show_game_state to the ui with initial game state' do
          expect(ui).to have_received(:show_game_state).with([nil], initial_lives)
        end

        it 'sends get_guess to the ui' do
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

          #TODO It decrements the lives remaining after the invalid guess?
          it 'sends show_game_state to the ui after the first guess with the current game state' do
            expect(ui).to have_received(:show_game_state).with([nil], 1)
          end

          it_behaves_like 'a won game', 1
        end

        context 'and the final guess is incorrect' do
          let(:guesses) { ['z', 'x'] }

          #TODO It decrements the lives remaining after the invalid guess?
          it 'sends show_game_state to the ui with the game state after the first guess' do
            expect(ui).to have_received(:show_game_state).with([nil], 1)
          end

          it_behaves_like 'a lost game'
        end

        context 'and the first guess is invalid but the final guess is correct' do
          let(:guesses) { ['1', 'p'] }
          # The invalid guess does not count as a guess
          let(:guesses_required) { 1 }

          it 'does not decrement the lives remaining after the invalid guess' do
            #Once from before the game loop and once from in game loop
            expect(ui).to have_received(:show_game_state).with([nil], initial_lives).twice
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

        it 'sends show_game_state to the ui with the game state after the first guess' do
          expect(ui).to have_received(:show_game_state).with([nil, nil], 1)
        end

        it_behaves_like 'a lost game'
      end

      context 'and 1 of the letters are guessed correctly' do
        let(:guesses) { ['i', 'e', 's'] }

        it 'sends show_game_state to the ui after the correct guess' do
          expect(ui).to have_received(:show_game_state).with(['I', nil], initial_lives)
        end

        it 'sends show_game_state to the ui after the 1st incorrect guess' do
          expect(ui).to have_received(:show_game_state).with(['I', nil], 1)
        end

        it_behaves_like 'a lost game'
      end

      context 'and all of the letters are guess correctly' do
        let(:guesses) { ['i', 't'] }

        it 'sends show_game_state to the ui after the 1st guess' do
          expect(ui).to have_received(:show_game_state).with(['I', nil], initial_lives)
        end

        it_behaves_like 'a won game', 0
      end
    end
  end
end
