# frozen_string_literal: true

require_relative 'board_builder'
require_relative 'coords_converter'
require_relative 'move_validator.rb'

class Main
  def initialize
    @board = BoardBuilder.new_board
    @current_color = 'white'
  end

  def run
    loop do
      if checkmate?
        puts "#{@current_color} has lost the game. checkmate"
        break
      end

      puts @board
      puts "It is #{@current_color}'s turn. Enter the square of the piece you want to move (e.g., 'e2'):"
      from = CoordsConverter.to_internal(gets.chomp)
      unless MoveValidator.valid_from?(@board, from, @current_color)
        puts 'invalid square. Please try again'
        next
      end

      puts "Enter a square you want the piece to move (e.g., 'e2'):"
      to = CoordsConverter.to_internal(gets.chomp)
      unless MoveValidator.valid_to?(@board, to, from, @current_color)
        puts 'invalid square. Please try again'
        next
      end


      @board.get_piece(from).move(to)

      next_color
    end
  end

  def checkmate?
    king = @current_color == 'white' ? @board.white_king : @board.black_king
    in_check = @board.under_attack?(king.location, king.color)
    return in_check && @board.saver_pieces(@current_color).empty?
  end

  def next_color
    @current_color = @current_color == 'white' ? 'black' : 'white'
  end
end

Main.new.run
