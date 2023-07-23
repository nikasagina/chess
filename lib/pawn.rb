require_relative "piece.rb"

class Pawn < Piece
  attr_reader :first_move
  def initialize(board, location, color)
    super
    @first_move = true;
  end

  def valid_moves
    dir = @color == "white" ? 1 : -1
    moves = []

    new_pos = [@location[0] + dir, @location[1]]
    if @board.aviable_location?(new_pos)
      moves.append(new_pos)
      if @first_move && @board.aviable_location?([new_pos[0] + dir, new_pos[1]])
        moves.append([new_pos[0] + dir, new_pos[1]])
      end
    end

    moves
  end

  def valid_captures
    dir = @color == "white" ? 1 : -1
    moves = []

    if @board.aviable_attack? [@location[0] + dir, @location[1] + 1]
      moves.append new_pos
    end

    if @board.aviable_attack? [@location[0] + dir, @location[1] - 1]
      moves.append new_pos
    end

    moves
  end

  def to_s
    white? ? '♙' : '♟︎'
  end
end
