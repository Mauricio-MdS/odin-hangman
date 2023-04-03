# frozen_string_literal: true

require 'json'
require_relative 'dictionary'

# State of the hangman game
class GameState
  attr_accessor :guessed, :letters, :misses, :quit_flag, :word

  def initialize
    self.quit_flag = false
  end

  def clean_state
    File.delete('save.txt') if saved_state?
  end

  def load_state
    saved = JSON.parse(File.open('save.txt', 'r', &:readline))
    self.word = saved['word']
    self.guessed = saved['guessed']
    self.letters = saved['letters']
    self.misses = saved['misses']
    clean_state
  end

  def new_state
    clean_state
    self.word = Dictionary.provide_word.split('')
    self.guessed = Array.new(word.length)
    self.letters = []
    self.misses = 0
  end

  def save_and_quit
    self.quit_flag = true
    puts 'Saving state'
    File.open('save.txt', 'w') do |file|
      file.puts JSON.generate(guessed: guessed, letters: letters, misses: misses, word: word)
    end
  end

  def saved_state?
    File.exist?('save.txt')
  end
end
