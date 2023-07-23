# frozen_string_literal: true

require_relative 'piece'

class Knight < Piece
  DIR = [[1, 2], [2, 1], [-1, 2], [2, -1], [-1, -2], [-2, -1], [-2, 1], [1, -2]].freeze

  def valid_moves
    moves = Set.new

    DIR.each do |dir|
      loc = [@location[0] + dir[0], @location[1] + dir[1]]
      moves.add(loc) if @board.aviable_location?(loc)
    end

    moves
  end

  def valid_captures
    moves = Set.new

    DIR.each do |dir|
      loc = [@location[0] + dir[0], @location[1] + dir[1]]
      moves.add(loc) if @board.aviable_attack?(loc, @color)
    end

    moves
  end

  def to_s
    white? ? '♘' : '♞'
  end
end
