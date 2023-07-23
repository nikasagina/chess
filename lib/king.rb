# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  def to_s
    white? ? '♔' : '♚'
  end
end
