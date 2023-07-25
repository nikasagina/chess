# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  DIR = [[1, 1], [1, 0], [0, 1], [-1, 1], [1, -1], [0, -1], [-1, 0], [-1, -1]].freeze

  def move(loc)
    valid = valid_moves.include?(loc) || valid_captures.include?(loc)
    if valid
      @board.set_piece(self, loc)
      @board.set_piece(nil, @location)
      @location = loc
      # update castle_aviable
    end
    valid
  end

  def valid_moves
    moves = Set.new

    DIR.each do |dir|
      loc = [@location[0] + dir[0], @location[1] + dir[1]]
      moves.add(loc) if @board.aviable_location?(loc) && !@board.under_attack?(loc, @color)
    end

    moves
  end

  def valid_captures
    moves = Set.new

    DIR.each do |dir|
      loc = [@location[0] + dir[0], @location[1] + dir[1]]
      moves.add(loc) if @board.aviable_attack?(loc, @color) && !@board.under_attack?(loc, @color)
    end

    moves
  end

  def to_s
    white? ? '♔' : '♚'
  end
end
