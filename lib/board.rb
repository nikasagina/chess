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
  attr_accessor :castle_aviable

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
    @castle_aviable = {}
    @castle_aviable['white'] = [true, true]
    @castle_aviable['black'] = [true, true]
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

  def under_attack?(location, color)
    # Check for Knights
    knight_moves = [
      [-2, -1],
      [-2, 1],
      [-1, -2],
      [-1, 2],
      [1, -2],
      [1, 2],
      [2, -1],
      [2, 1]
    ]
    knight_moves.each do |move|
      new_location = [location[0] + move[0], location[1] + move[1]]
      if in_bounds?(new_location) && is_ocupied?(new_location) && get_piece(new_location).instance_of?(Knight) && get_piece(new_location).color != color
        return true
      end
    end

    # Check for Rooks and Queens along rows and columns
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |direction|
      new_location = location.dup
      loop do
        new_location = [new_location[0] + direction[0], new_location[1] + direction[1]]
        break unless in_bounds?(new_location)

        next unless is_ocupied?(new_location)

        piece = get_piece(new_location)
        return true if piece.color != color && (piece.instance_of?(Rook) || piece.instance_of?(Queen))

        break
      end
    end

    # Check for Bishops and Queens along diagonals
    [[-1, -1], [-1, 1], [1, -1], [1, 1]].each do |direction|
      new_location = location.dup
      loop do
        new_location = [new_location[0] + direction[0], new_location[1] + direction[1]]
        break unless in_bounds?(new_location)

        next unless is_ocupied?(new_location)

        piece = get_piece(new_location)
        return true if piece.color != color && (piece.instance_of?(Bishop) || piece.instance_of?(Queen))

        break
      end
    end

    # Check for Pawns
    pawn_direction = color == 'white' ? 1 : -1
    [[pawn_direction, -1], [pawn_direction, 1]].each do |move|
      new_location = [location[0] + move[0], location[1] + move[1]]
      if in_bounds?(new_location) && is_ocupied?(new_location) && get_piece(new_location).instance_of?(Pawn) && get_piece(new_location).color != color
        return true
      end
    end

    # Check for Kings
    king_moves = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ]
    king_moves.each do |move|
      new_location = [location[0] + move[0], location[1] + move[1]]
      if in_bounds?(new_location) && is_ocupied?(new_location) && get_piece(new_location).instance_of?(King) && get_piece(new_location).color != color
        return true
      end
    end

    false
  end
end
