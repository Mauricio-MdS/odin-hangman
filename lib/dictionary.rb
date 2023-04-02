# frozen_string_literal: true

# Provides valid word from google dictionary
class Dictionary
  @words = File.open('google-10000-english-no-swears.txt', 'r', &:readlines)

  def self.provide_word
    word = ''
    word = @words.sample.chomp until valid_word?(word)
    word
  end

  class << self
    private

    def valid_word?(word)
      word.length.between?(5, 12)
    end
  end
end
