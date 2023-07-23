# frozen_string_literal: true

require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require 'colorize'

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
  end

  def set_piece(piece, location)
    @board[location[0]][location[1]] = piece
  end

  def get_piece(location)
    @board[location[0]][location[1]]
  end

  def to_s
    str = ''
    @board.reverse.each.with_index do |row, i|
      str += "#{8 - i} "
      row.each.with_index do |piece, j|
        if piece.nil?
          str += if (i + j).even?
                   '  '.colorize(background: :yellow)
                 else
                   '  '.colorize(background: :white)
                 end
        else
          color = piece.color
          str += if (i + j).even?
                   piece.to_s.colorize(color: color, background: :yellow) + ' '.colorize(background: :yellow)
                 else
                   piece.to_s.colorize(color: color, background: :white) + ' '.colorize(background: :white)
                 end
        end
      end
      str += "\n"
    end
    "#{str}  a b c d e f g h"
  end

  def aviable_location?(location)
    in_bounds?(location) && !is_ocupied?(location)
  end

  def aviable_attack?(location, color)
    in_bounds?(location) && is_ocupied?(location) && board[location[0]][location[1]].color != color
  end

  def in_bounds?(location)
    location[0] >= 0 && location[0] < 8 && location[1] >= 0 && location[1] < 8
  end

  def is_ocupied?(location)
    board[location[0]][location[1]] != nil
  end
end
