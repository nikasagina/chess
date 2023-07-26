# frozen_string_literal: true

require_relative 'piece'

class Rook < Piece
  def initialize(board, location, color)
    super

    if location[0] == 0 && (location[1] == 0 || location[1] == 7)
      @isKingside = true
    elsif location[0] == 7 && (location[1] == 0 || location[1] == 7)
      @isKingside = false
    else
    end
  end

  def move(loc)
    valid = valid_moves.include?(loc) || valid_captures.include?(loc)
    if valid
      @board.set_piece(self, loc)
      @board.set_piece(nil, @location)
      @location = loc
      unless @isKingside.nil?
        if @isKingside
          board.castle_aviable[@color][0] = false
        else
          board.castle_aviable[@color][1] = false
        end
      end
    end
    valid
  end

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
      row -= 1
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
      col -= 1
      break unless @board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    moves
  end

  def to_s
    white? ? '♖' : '♜'
  end
end
