# frozen_string_literal: true

require 'set'
require_relative 'piece_square_tables'

class Piece
  attr_reader :color, :board
  attr_accessor :location

  def initialize(board, location, color)
    @board = board
    @color = color
    @location = location
    board.set_piece(self, location)
  end

  # moves the piece and returns true if it is a legal move, else returns false
  def move(loc)
    valid = valid_moves.include?(loc) || valid_captures.include?(loc)
    if valid
      @board.set_piece(self, loc)
      @board.set_piece(nil, @location)
      @location = loc
    end
    valid
  end

  # move method might be overridden, but this method should not
  def mock_move(loc)
    @commited_piece = @board.get_piece(loc)
    @board.set_piece(self, loc)
    @board.set_piece(nil, @location)
    @location = loc
  end

  def revert_mock_move(loc)
    @board.set_piece(self, loc)
    @commited_piece.nil? ? @board.set_piece(nil, @location) : @board.set_piece(@commited_piece, @commited_piece.location)
    @location = loc
  end

  def valid_moves
    raise NotImplementedError
  end

  def valid_captures
    raise NotImplementedError
  end

  def points
    raise NotImplementedError
  end

  def white?
    color == 'white'
  end
end
