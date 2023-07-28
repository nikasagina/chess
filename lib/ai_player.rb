# frozen_string_literal: true

require_relative 'player'

class AiPlayer < Player
  def next_move(board)
    pieces = board.pieces(@color)

    moves = []
    pieces.each do |piece|
      from = piece.location
      piece.valid_moves.each do |to|
        moves.append([from, to]) if MoveValidator.valid_move?(board, from, to, @color)
      end
    end

    captures = []
    pieces.each do |piece|
      from = piece.location
      piece.valid_captures.each do |to|
        captures.append([from, to]) if MoveValidator.valid_move?(board, from, to, @color)
      end
    end

    # Try to capture opponent's piece if possible
    return captures.sample unless captures.empty?

    # If no capture is possible, move a piece randomly
    moves.sample
  end
end
