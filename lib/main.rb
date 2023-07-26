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
      king = @current_color == 'white' ? @board.white_king : @board.black_king
      in_check = @board.under_attack?(king.location, king.color)
      if in_check && @board.saver_pieces(@current_color).empty?
        puts "Player #{@current_color} has lost the game"
        break
      end

      puts @board
      puts "It is #{@current_color}'s turn. Enter the square of the piece you want to move (e.g., 'e2'):"
      from = CoordsConverter.to_internal(gets.chomp)
      if from.nil?
        puts 'invalid square. Please try again'
        next
      end

      piece = @board.get_piece(from)
      if piece.nil? || piece.color != @current_color || (in_check && !@board.saver_pieces(@current_color).include?(piece))
        puts 'Invalid move. Please try again.'
        next
      end

      puts "Enter a square you want the piece to move (e.g., 'e2'):"
      to = CoordsConverter.to_internal(gets.chomp)
      if to.nil?
        puts 'invalid square. Please try again'
        next
      end

      # check if the user wants to castle
      if @board.get_piece(from) == king && @board.get_piece(to).instance_of?(Rook) && @board.get_piece(to).color == @current_color
        # check if the user is allowed to castle
        rook = @board.get_piece(to)
                 rook.location[1] == 0 && king.castle(:queenside)
          puts 'Invalid move. Please try again.'
          next
        end
      end

      unless piece.move(to)
        puts 'Invalid move. Please try again.'
        next
      end

      # move piece back since king is still in check
      if @board.under_attack?(king.location, king.color)
        piece.move(from)
        puts 'Invalid move. Please try again.'
        next
      end

      @current_color = @current_color == 'white' ? 'black' : 'white'
    end
  end
end

Main.new.run
