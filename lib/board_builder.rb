require_relative "board.rb"

class BoardBuilder
  def self.new_board
    board = Board.new

    8.times do |col|
      white_location = [1, col]
      black_location = [6, col]
      board.set_piece(Pawn.new(board, white_location, "white"))
      board.set_piece(Pawn.new(board, black_location, "black"))
    end

    board.set_piece(Rook.new(board, [0, 0], "white"))
    board.set_piece(Rook.new(board, [0, 7], "white"))
    board.set_piece(Rook.new(board, [7, 7], "black"))
    board.set_piece(Rook.new(board, [7, 0], "black"))

    board.set_piece(Knight.new(board, [0, 1], "white"))
    board.set_piece(Knight.new(board, [0, 6], "white"))
    board.set_piece(Knight.new(board, [7, 1], "black"))
    board.set_piece(Knight.new(board, [7, 6], "black"))

    board.set_piece(Bishop.new(board, [0, 2], "white"))
    board.set_piece(Bishop.new(board, [0, 5], "white"))
    board.set_piece(Bishop.new(board, [7, 2], "black"))
    board.set_piece(Bishop.new(board, [7, 5], "black"))

    board.set_piece(Queen.new(board, [0, 3], "white"))
    board.set_piece(Queen.new(board, [7, 3], "black"))

    board.set_piece(King.new(board, [0, 4], "white"))
    board.set_piece(King.new(board, [7, 4], "black"))

    board
  end

end
