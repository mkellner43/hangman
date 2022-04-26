require_relative 'save_game'
require_relative 'text'
require 'rubygems'
require 'rest-client'
require 'rubocop'

puts "\nHangman Game Initalized!"

File.open('word_bank.txt', 'w') do |file|
  file.write(RestClient.get('https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt'))
end

class Game
  include SaveFile
  include Message

  attr_reader :random_word, :display_arr, :guessed, :turn_count

  def initialize
    @guessed = []
    @display_arr = []
    @random_word = pick_word
    @turn_count = 0
  end

  def start_new_game
    puts messages('start_message')
    display
  end

  def pick_word
    random_word = File.readlines('word_bank.txt').sample
    if (random_word.length > 5) && (random_word.length < 12)
      random_word
    else
      pick_word
    end
  end

  def display
    count = 0
    puts "\n#{@random_word}\n"
    until count == @random_word.length - 1
      @display_arr.push('_')
      count += 1
    end
    guess
  end

  def guess
    win_or_lose?
    puts "#{@display_arr.join(' ')}\n"
    puts messages('guess')
    guess = gets.chomp.to_s.downcase
    check(guess)
  end

  def valid_guess?(guess)
    if guess.match(/[a-z]/) && (guess.length == 1) && (guessed.include?(guess) == false)
      true
    elsif guess == 'save'
      save_this_game
    elsif guess == 'load'
      load_this_game
    elsif guess == 'exit'
      exit
    else
      puts messages('invalid_guess')
      guess
    end
  end

  def game_start_type
    puts messages('load_or_new')
    @answer = gets.chomp.to_s
    case @answer
    when '1'
      start_new_game
    when '2'
      load_this_game
    else
      puts messgaes('invalid_game_start')
      @answer = gets.chomp.to_s
      game_start_type
    end
  end

  def check(guess)
    correct = false
    valid_guess?(guess)
    @random_word.split('').each_with_index do |letter, idx|
      next unless letter == guess

      @display_arr[idx].replace(letter)
      puts messages('correct_guess') unless correct == true
      correct = true
    end
    unless correct == true
      puts messages('incorrect_guess')
      @turn_count += 1
      puts messages('guesses_left')
    end
    guessed_letters(guess) unless %w[save load].include?(guess)
  end

  def win_or_lose?
    unless @display_arr.include?('_') && (@turn_count < 9)
      puts messages('winner')
      puts messages('display_word')
      game_over
    end
    if @turn_count == 8
      puts messages('lost')
      game_over
    end
  end

  def game_over
    puts messages('replay')
    play_again = gets.chomp.to_s
    play_again == 'y' ? pick_word : exit
  end

  def guessed_letters(guess)
    @guessed.push(guess)
    puts messages('guessed')
    guess()
  end
end

Game.new.game_start_type
