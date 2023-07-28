# frozen_string_literal: true

require_relative 'board'

class MoveValidator
  def self.valid_from?(board, location, color, in_check)
    return false if location.nil?

    piece = board.get_piece(location)
    !(piece.nil? || piece.color != color || (in_check && !board.saver_pieces(color).include?(piece)))
  end

  def self.valid_to?(board, to, from, color, king)
    piece = board.get_piece(from)

    return false if to.nil?

    # check if the user wants to castle
    if board.get_piece(from) == king && board.get_piece(to).instance_of?(Rook) && board.get_piece(to).color == color
      # check if the user is allowed to castle
      rook = board.get_piece(to)

      return rook.location[1] == 0 && king.castle(:queenside) || rook.location[1] == 7 && king.castle(:kingside)
    end

    return false unless piece.move(to)

    success = !board.under_attack?(king.location, king.color)

    # move the piece back
    piece.move(from)

    success
  end
end
