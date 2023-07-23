require 'set'

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

  def valid_moves
    raise NotImplementedError
  end

  def valid_captures
    raise NotImplementedError
  end

  def white?
    color == 'white'
  end


end
