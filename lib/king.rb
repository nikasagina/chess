# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  DIR = [[1, 1], [1, 0], [0, 1], [-1, 1], [1, -1], [0, -1], [-1, 0], [-1, -1]].freeze

  def initialize(board, location, color)
    super
    white? ? board.set_white_king(self) : board.set_black_king(self)
  end

  def move(loc)
    valid = valid_moves.include?(loc) || valid_captures.include?(loc)
    if valid
      @board.set_piece(self, loc)
      @board.set_piece(nil, @location)
      @location = loc
      @board.castle_aviable[@color][0] = false
      @board.castle_aviable[@color][1] = false
    end
    valid
  end

  def valid_moves
    moves = Set.new

    DIR.each do |dir|
      loc = [@location[0] + dir[0], @location[1] + dir[1]]
      moves.add(loc) if @board.aviable_location?(loc) && !@board.under_attack?(loc, @color)
    end

    moves
  end

  def valid_captures
    moves = Set.new

    DIR.each do |dir|
      loc = [@location[0] + dir[0], @location[1] + dir[1]]
      moves.add(loc) if @board.aviable_attack?(loc, @color) && !@board.under_attack?(loc, @color)
    end

    moves
  end

  def castle(side)
    return false unless @board.castle_aviable[@color][side == :kingside ? 0 : 1]

    row = white? ? 0 : 7

    if side == :kingside
      # check if rook is on correct corner
      return false unless @board.get_piece([row, 7]).instance_of?(Rook) && @board.get_piece([row, 7]).color == @color
      # check if the path is free (no pieces on it and no enemy attacking)
      return false unless @board.get_piece([row,
                                            5]).nil? && @board.get_piece([row,
                                                                          6]).nil? && !@board.under_attack?([row, 5],
                                                                                                            @color) && !@board.under_attack?(
                                                                                                              [row,
                                                                                                               6], @color
                                                                                                            )

      rook_loc = [row, 7]
      new_king_loc = [row, 6]
      new_rook_loc = [row, 5]
    else
      # check if rook is on correct corner
      return false unless @board.get_piece([row, 0]).instance_of?(Rook) && @board.get_piece([row, 0]).color == @color
      # check if the path is free (no pieces on it and no enemy attacking)
      return false unless @board.get_piece([row,
                                            1]).nil? && @board.get_piece([row,
                                                                          2]).nil? && @board.get_piece([row,
                                                                                                        3]).nil? && !@board.under_attack?([row, 1],
                                                                                                                                          @color) && !@board.under_attack?(
                                                                                                                                            [
                                                                                                                                              row, 2
                                                                                                                                            ], @color
                                                                                                                                          ) && !@board.under_attack?(
                                                                                                                                            [
                                                                                                                                              row, 3
                                                                                                                                            ], @color
                                                                                                                                          )

      rook_loc = [row, 0]
      new_king_loc = [row, 2]
      new_rook_loc = [row, 3]
    end

    return false unless @board.get_piece(rook_loc).instance_of?(Rook) && @board.get_piece(rook_loc).color == @color

    # move king
    @location = new_king_loc
    @board.castle_aviable[@color][0] = false
    @board.castle_aviable[@color][1] = false
    @board.set_piece(self, new_king_loc)

    # move rook
    rook = @board.get_piece(rook_loc)
    rook.location = new_rook_loc
    @board.set_piece(rook, new_rook_loc)

    true
  end

  def to_s
    white? ? '♔' : '♚'
  end
end
