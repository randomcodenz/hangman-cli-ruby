require 'spec_helper'
require 'hangman_cli'

describe HangmanCLI do
  it 'has a version number' do
    expect(HangmanCLI::VERSION).not_to be nil
  end
end
