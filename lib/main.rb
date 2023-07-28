# frozen_string_literal: true

require_relative 'game'

puts 'Welcome to Chess!'

loop do
  puts 'Please choose an option:'
  puts '1. New player vs player game'
  puts '2. New player vs computer game'
  puts '3. Load saved game'
  puts "type 'save' at any point of the game to save"
  choice = gets.chomp.to_i

  case choice
  when 1
    Game.new_game(HumanPlayer.new('white'), HumanPlayer.new('black')).run
  when 2
    puts 'Please choose a difficulty level:'
    puts '1. Easy'
    puts '2. Medium'
    level = gets.chomp.to_i
    case level
    when 1
      Game.new_game(HumanPlayer.new('white'), AiPlayer.new('black')).run
    when 2
      Game.new_game(HumanPlayer.new('white'), SmartAiPlayer.new('black')).run
    else
      puts 'Invalid choice, please try again.'
    end
  when 3
    puts 'Please enter the ID of the saved game:'
    id = gets.chomp.to_i
    Game.load_game(id).run
  else
    puts 'Invalid choice, please try again.'
  end

  puts 'Would you like to play again? (y/n)'
  play_again = gets.chomp.downcase
  break unless play_again == 'y'
end

puts 'Thanks for playing Chess!'
