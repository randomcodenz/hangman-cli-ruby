require 'spec_helper'
require 'hangman_cli'
require 'hangman_cli/messages'
require 'hangman_cli/cli'

describe HangmanCli do
  it 'has a version number' do
    expect(HangmanCli::VERSION).not_to be nil
  end

  it 'prints a welcome message' do
    expect { HangmanCli::CLI.start }.to output(HangmanCli::WELCOME + "\n").to_stdout
  end
end
