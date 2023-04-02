# frozen_string_literal: true

require_relative 'dictionary'

# Game logic
class Hangman

  HANGMANPICS = ['', '''
    +---+
    |   |
        |
        |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
        |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
    |   |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
   /|   |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
   /|\  |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
   /|\  |
   /    |
        |
  =========''', '''
    +---+
    |   |
    O   |
   /|\  |
   / \  |
        |
  ========='''].freeze

  def self.start
    @word = Dictionary.provide_word.split('')
    @guessed = Array.new(@word.length)
    @letters = []
    @misses = 0
    play_round until finished?
  end

  class << self
    private

    def check_letter(attempt)
      miss = true
      @word.each_with_index do |letter, index|
        if attempt == letter
          @guessed[index] = attempt
          miss = false
        end
      end
      @misses += 1 if miss
    end

    def display
      puts HANGMANPICS[@misses]
      @guessed.each do |letter|
        print " #{letter || '_'}"
      end
      print "\t Attempted letters: "
      puts @letters.sort.join(', ')
      puts
      puts 'What letter would you like to try?'
    end

    def read_letter
      letter = $stdin.gets[0].downcase
      letter = $stdin.gets[0].downcase until valid_letter?(letter)
      @letters.push(letter)
      letter
    end

    def finished?
      @misses == 7
    end

    def play_round
      display
      letter = read_letter
      check_letter(letter)
    end

    def valid_letter?(letter)
      valid = letter.match?(/[a-z]/) && !@letters.include?(letter)
      puts 'Invalid input' unless valid
      valid
    end
  end
end

Hangman.start
