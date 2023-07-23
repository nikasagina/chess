class Piece
  attr_reader :color, :board
  attr_accessor :location

  def initialize(board, location, color)
    @board = board
    @color = color
    @location = location
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
