# frozen_string_literal: true

require_relative 'piece'

class Bishop < Piece
  def valid_moves
    moves = Set.new

    row = @location[0]
    col = @location[1]
    loop do
      row += 1
      col += 1
      break unless @board.aviable_location?([row, col])

      moves.add([row, col])
    end

    row = @location[0]
    col = @location[1]
    loop do
      row -= 1
      col -= 1
      break unless @board.aviable_location?([row, col])

      moves.add([row, col])
    end

    row = @location[0]
    col = @location[1]
    loop do
      row -= 1
      col += 1
      break unless @board.aviable_location?([row, col])

      moves.add([row, col])
    end

    row = @location[0]
    col = @location[1]
    loop do
      row += 1
      col -= 1
      break unless @board.aviable_location?([row, col])

      moves.add([row, col])
    end

    moves
  end

  def valid_captures
    moves = Set.new

    row = @location[0]
    col = @location[1]
    loop do
      row += 1
      col += 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    loop do
      row += 1
      col -= 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    loop do
      row -= 1
      col += 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    loop do
      row -= 1
      col -= 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    moves
  end

  def score
    white? ? 330 + Piece_Square_Tables::WHITE_BISHOP_TABLE[[@location[1], @location[0]]] : 330 + Piece_Square_Tables::BLACK_BISHOP_TABLE[[@location[1], @location[0]]]
  end


  def to_s
    white? ? '♗' : '♝'
  end
end
