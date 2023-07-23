require_relative "pawn.rb"
require_relative "rook.rb"
require_relative "knight.rb"
require_relative "bishop.rb"
require_relative "queen.rb"
require_relative "king.rb"

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
  end

  def set_piece(piece, location)
    @board[location[0]][location[1]] = piece
  end

  def set_piece(piece)
    @board[piece.location[0]][piece.location[1]] = piece
  end

  def get_piece(location)
    @board[location[0]][location[1]]
  end

  def to_s
    str = ""
    @board.each.with_index do |row, i|
      str += "#{8 - i} "
      str += row.join(" ").to_s + "\n"
    end
    str + "  a b c d e f g h"
  end

  def aviable_location?(location)
    in_bounds?(location) && !is_ocupied?(location)
  end

  def aviable_attack?(location, color)
    in_bounds?(location) && is_ocupied?(location)  && board[location[0]][location[1]].color != color
  end

  def in_bounds?(location)
    location[0] >= 0 && location[0] < 8 && location[1] >= 0 && location[1] < 8
  end

  def is_ocupied?(location)
    board[location[0]][location[1]] != nil
  end
end
