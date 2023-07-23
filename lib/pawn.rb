require_relative "piece.rb"

class Pawn < Piece
  attr_reader :first_move
  def initialize(board, location, color)
    super
    @first_move = true;
  end

  def move(loc)
    valid = valid_moves.include?(loc) || valid_captures.include?(loc)
    if valid
      @board.set_piece(self, loc)
      @board.set_piece(nil, @location)
      @location = loc
      @first_move = false if @first_move
      true
    end
    valid
  end

  def valid_moves
    dir = @color == "white" ? 1 : -1
    moves = Set.new

    new_pos = [@location[0] + dir, @location[1]]
    if @board.aviable_location?(new_pos)
      moves.add(new_pos)
      if @first_move && @board.aviable_location?([new_pos[0] + dir, new_pos[1]])
        moves.add([new_pos[0] + dir, new_pos[1]])
      end
    end

    moves
  end

  def valid_captures
    dir = @color == "white" ? 1 : -1
    moves = Set.new

    if @board.aviable_attack?([@location[0] + dir, @location[1] + 1], @color)
      moves.add [@location[0] + dir, @location[1] + 1]
    end

    if @board.aviable_attack?([@location[0] + dir, @location[1] - 1], @color)
      moves.add [@location[0] + dir, @location[1] - 1]
    end

    moves
  end

  def to_s
    white? ? '♙' : '♟︎'
  end
end
