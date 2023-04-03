# frozen_string_literal: true

require_relative 'game_state'

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
    @state = GameState.new
    play_round until finished?
    game_over unless @state.quit_flag
  end

  class << self
    private

    def check_letter(attempt)
      return save_and_quit if attempt == ''

      miss = true
      @state.word.each_with_index do |letter, index|
        if attempt == letter
          @state.guessed[index] = attempt
          miss = false
        end
      end
      @state.misses += 1 if miss
    end

    def display
      puts HANGMANPICS[@state.misses]
      @state.guessed.each do |letter|
        print " #{letter || '_'}"
      end
      print "\t Attempted letters: "
      puts @state.letters.sort.join(', ')
      puts
      puts 'What letter would you like to try? Press ENTER with no input for exit.'
    end

    def game_over
      if @state.misses == 7
        puts HANGMANPICS.last
        print 'GAME OVER! You are dead! '
      elsif @state.word == @state.guessed
        puts @state.word.join(' ')
        print 'Coungratulations! You won!!! '
      end
      puts "The word was #{@state.word.join('')}."
    end

    def finished?
      @state.misses == 7 || @state.word == @state.guessed || @state.quit_flag
    end

    def play_round
      display
      letter = read_letter
      check_letter(letter)
    end

    def read_letter
      letter = $stdin.gets.chomp[0].to_s.downcase
      letter = $stdin.gets.chomp[0].to_s.downcase until valid_letter?(letter)
      @state.letters.push(letter) unless letter == ''
      letter
    end

    def save_and_quit
      @state.quit_flag = true
      puts 'Saving state'
    end

    def valid_letter?(letter)
      valid = (letter.match?(/[a-z]/) && !@state.letters.include?(letter)) || ''
      puts 'Invalid input' unless valid
      valid
    end
  end
end

Hangman.start
