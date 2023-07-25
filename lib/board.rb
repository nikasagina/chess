# frozen_string_literal: true

require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require 'colorize'

class Board
  attr_reader :board, :white_king, :black_king
  attr_accessor :castle_aviable

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
    @castle_aviable = {}
    @castle_aviable['white'] = [true, true]
    @castle_aviable['black'] = [true, true]
    @white_king = nil
    @black_king = nil
  end

  def set_white_king(piece)
    @white_king = piece
  end

  def set_black_king(piece)
    @black_king = piece
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

  # Returns all pieces of a given color
  def pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  # Returns all pieces locations attacking a given location
  def attacking_pieces(loc, color)
    Set.new(@board.flatten.compact.select { |piece| piece.valid_captures.include?(loc) && piece.color != color }.map {|piece| piece.location})
  end

  def saver_pieces(color)
    all_pieces = pieces(color)
    king = color == 'white' ? white_king : black_king
    pieces = Set.new

    # Check if king's moves
    king.valid_moves.empty? && king.valid_captures.empty? ? nil : pieces.add(king)

    # Check if a piece can capture the attacker
    all_pieces.each do |piece|
      pieces.add(piece) unless (piece.valid_captures & attacking_pieces(king.location, king.color)).empty?
    end

    # Check if a piece can block the attacker
    all_pieces.each do |piece|
      next if piece == king

      piece.valid_moves.each do |move|
        temp_board = deep_copy
        temp_piece = temp_board.get_piece(piece.location)
        temp_piece.move(move)

        unless temp_board.under_attack?(temp_board.get_piece(king.location).location, king.color)
          pieces.add(piece)
        end
      end
    end

    pieces
  end

  # Returns a deep copy of the board
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end
end
