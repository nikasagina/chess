# frozen_string_literal: true

require_relative 'board'

class BoardBuilder
  def self.new_board
    board = Board.new

    8.times do |col|
      Pawn.new(board, [1, col], 'white')
      Pawn.new(board, [6, col], 'black')
    end

    Rook.new(board, [0, 0], 'white')
    Rook.new(board, [0, 7], 'white')
    Rook.new(board, [7, 7], 'black')
    Rook.new(board, [7, 0], 'black')

    Knight.new(board, [0, 1], 'white')
    Knight.new(board, [0, 6], 'white')
    Knight.new(board, [7, 1], 'black')
    Knight.new(board, [7, 6], 'black')

    Bishop.new(board, [0, 2], 'white')
    Bishop.new(board, [0, 5], 'white')
    Bishop.new(board, [7, 2], 'black')
    Bishop.new(board, [7, 5], 'black')

    Queen.new(board, [0, 3], 'white')
    Queen.new(board, [7, 3], 'black')

    King.new(board, [0, 4], 'white')
    King.new(board, [7, 4], 'black')

    board
  end
end
