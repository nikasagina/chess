require_relative "piece.rb"

class Queen < Piece
  def initialize(board, location, color)
    super
  end

  def valid_moves
    moves = Set.new

    row = @location[0]
    col = @location[1]
    while true
      row += 1
      if @board.aviable_location?([row, col])
        moves.add([row, col])
      else
        break
      end
    end

    row = @location[0]
    col = @location[1]
    while true
      row += 1
      col += 1
      if @board.aviable_location?([row, col])
        moves.add([row, col])
      else
        break
      end
    end

    row = @location[0]
    col = @location[1]
    while true
      col += 1
      if @board.aviable_location?([row, col])
        moves.add([row, col])
      else
        break
      end
    end

    row = @location[0]
    col = @location[1]
    while true
      row -= 1
      col += 1
      if @board.aviable_location?([row, col])
        moves.add([row, col])
      else
        break
      end
    end

    row = @location[0]
    col = @location[1]
    while true
      row -= 1
      if @board.aviable_location?([row, col])
        moves.add([row, col])
      else
        break
      end
    end

    row = @location[0]
    col = @location[1]
    while true
      row -= 1
      col -= 1
      if @board.aviable_location?([row, col])
        moves.add([row, col])
      else
        break
      end
    end

    row = @location[0]
    col = @location[1]
    while true
      col -= 1
      if @board.aviable_location?([row, col])
        moves.add([row, col])
      else
        break
      end
    end

    row = @location[0]
    col = @location[1]
    while true
      row += 1
      col -= 1
      if @board.aviable_location?([row, col])
        moves.add([row, col])
      else
        break
      end
    end

    moves
  end

  def valid_captures
    moves = Set.new

    row = @location[0]
    col = @location[1]
    while true
      row += 1
      col += 1
      break if !@board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    while true
      row += 1
      col -= 1
      break if !@board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    while true
      row -= 1
      col += 1
      break if !@board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    while true
      row -= 1
      col -= 1
      break if !@board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    while true
      col += 1
      break if !@board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    while true
      row += 1
      break if !@board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    while true
      col -= 1
      break if !@board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    row = @location[0]
    col = @location[1]
    while true
      row -= 1
      break if !@board.aviable_location?([row, col])
    end
    moves.add([row, col]) if @board.aviable_attack?([row, col], @color)

    moves
  end

  def to_s
    white? ? '♕' : '♛'
  end
end
