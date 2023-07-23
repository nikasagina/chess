require_relative "piece.rb"

class Queen < Piece
  def initialize(board, location, color)
    super
  end

  def to_s
    white? ? '♕' : '♛'
  end
end
