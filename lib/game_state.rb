# frozen_string_literal: true

require_relative 'dictionary'

# State of the hangman game
class GameState
  attr_accessor :guessed, :letters, :misses, :quit_flag, :word

  def initialize(guessed = nil, letters = [], misses = 0, word = nil)
    self.word = word || Dictionary.provide_word.split('')
    self.guessed = guessed || Array.new(@word.length)
    self.letters = letters
    self.misses = misses
    self.quit_flag = false
  end

  def clean_state
    File.delete('save.txt') if File.exist?('save.txt')
  end

  def save_and_quit
    self.quit_flag = true
    puts 'Saving state'
    File.open('save.txt', 'w') { |file| file.print "#{guessed}\n#{letters}\n#{misses}\n#{word}" }
  end
end
