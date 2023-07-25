# frozen_string_literal: true

require_relative 'board_builder'
require_relative 'coords_converter'

class Main
  def initialize
    @board = BoardBuilder.new_board
    @current_color = 'white'
  end

  def run
    loop do
      puts @board
      puts "It is #{@current_color}'s turn. Enter a move (e.g., 'e2 e4'):"
      input = gets.chomp
      from, to = input.split.map { |coord| CoordsConverter.to_internal(coord) }

      piece = @board.get_piece(from)
      if piece.nil? || piece.color != @current_color
        puts 'Invalid move. Please try again.'
        next
      end

      if piece.move(to)
        @current_color = @current_color == 'white' ? 'black' : 'white'
      else
        puts 'Invalid move. Please try again.'
      end
    end
  end
end

Main.new.run
