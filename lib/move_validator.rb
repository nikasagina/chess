# frozen_string_literal: true

require_relative 'board'

class MoveValidator
  def self.valid_from?(board, location, color)
    king = color == 'white' ? board.white_king : board.black_king
    in_check = board.under_attack?(king.location, king.color)

    return false if location.nil?

    piece = board.get_piece(location)
    !(piece.nil? || piece.color != color || (in_check && !board.saver_pieces(color).include?(piece)))
  end

  def self.valid_to?(board, to, from, color)
    piece = board.get_piece(from)
    king = color == 'white' ? board.white_king : board.black_king

    return false if to.nil?

    # check if the user wants to castle
    if board.get_piece(from) == king && board.get_piece(to).instance_of?(Rook) && board.get_piece(to).color == color
      # check if the user is allowed to castle
      rook = board.get_piece(to)

      return rook.location[1] == 0 && king.castle(:queenside) || rook.location[1] == 7 && king.castle(:kingside)
    end

    return false unless piece.mock_move(to)

    success = !board.under_attack?(king.location, king.color)

    # move the piece back
    board.set_piece(piece, from)
    board.set_piece(nil, to)
    piece.location = from

    success
  end
end
