require 'spec_helper'
require 'hangman_cli'

describe HangmanCli do
  it 'has a version number' do
    expect(HangmanCli::VERSION).not_to be nil
  end
end
