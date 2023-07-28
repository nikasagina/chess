# frozen_string_literal: true

require_relative 'piece'

class Queen < Piece
  def valid_moves
    moves = Set.new

    row = @location[0]
    col = @location[1]
    loop do
      row += 1
      break unless @board.aviable_location?([row, col])

      moves.add([row, col])
    end

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
      col += 1
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
      row -= 1
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
      col -= 1
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

    row = @location[0]
    col = @location[1]
    loop do
      col += 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    loop do
      row += 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    loop do
      col -= 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    loop do
      row -= 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    moves
  end

  def score
    white? ? 900 + PieceSquareTables::WHITE_QUEEN_TABLE[[@location[1], @location[0]]] : 900 + PieceSquareTables::BLACK_QUEEN_TABLE[[@location[1], @location[0]]]
  end

  def to_s
    white? ? '♕' : '♛'
  end
end
