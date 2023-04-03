# frozen_string_literal: true

require_relative 'game_state'
require_relative 'hangman_pics'

# Game logic
class Hangman
  def self.start
    check_saved
    play_round until finished?
    game_over unless @state.quit_flag
  end

  private_class_method def self.check_attempt(attempt)
    return @state.save_and_quit if attempt.empty?

    miss = true
    @state.word.each_with_index do |letter, index|
      if attempt == letter
        @state.guessed[index] = attempt
        miss = false
      end
    end
    @state.misses += 1 if miss
  end

  private_class_method def self.check_saved
    @state = GameState.new
    return @state.new_state unless @state.saved_state?

    puts 'Saved state found. Input "load" to load game, or "new" for new game.'
    option = gets.chomp.to_s.downcase
    until %w[load new].include?(option)
      puts 'Invalid option'
      option = gets.chomp.to_s.downcase
    end
    option == 'load' ? @state.load_state : @state.new_state
  end

  private_class_method def self.display
    puts HangmanConstants::HANGMAN_PICS[@state.misses]
    @state.guessed.each do |letter|
      print " #{letter || '_'}"
    end
    print "\t Attempted letters: "
    puts @state.letters.sort.join(', ')
    puts
    puts 'What letter would you like to try? Press ENTER with no input for exit.'
  end

  private_class_method def self.game_over
    if @state.misses == 7
      puts HangmanConstants::HANGMAN_PICS.last
      print 'GAME OVER! You are dead! '
    elsif @state.word == @state.guessed
      puts @state.word.join(' ')
      print 'Coungratulations! You won!!! '
    end

    puts "The word was #{@state.word.join('')}."
    @state.clean_state
  end

  private_class_method def self.finished?
    @state.misses == 7 || @state.word == @state.guessed || @state.quit_flag
  end

  private_class_method def self.play_round
    display
    letter = read_letter
    check_attempt(letter)
  end

  private_class_method def self.read_letter
    letter = $stdin.gets.chomp[0].to_s.downcase
    letter = $stdin.gets.chomp[0].to_s.downcase until valid_letter?(letter)
    @state.letters.push(letter) unless letter == ''
    letter
  end

  private_class_method def self.valid_letter?(letter)
    valid = (letter.match?(/[a-z]/) && !@state.letters.include?(letter)) || letter == ''
    puts 'Invalid input' unless valid
    valid
  end
end

Hangman.start
