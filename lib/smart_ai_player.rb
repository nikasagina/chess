require_relative 'player'

class SmartAiPlayer < Player
  def initialize(color)
    super(color)
  end

  def next_move(board)
    pieces = board.pieces(@color)

    best_move = nil
    best_score = -Float::INFINITY

    pieces.each do |piece|
      from = piece.location
      moves = piece.valid_moves + piece.valid_captures
      moves.each do |to|
        if MoveValidator.valid_move?(board, from, to, @color)
          # Make a mock move
          piece.mock_move(to)

          # Evaluate the board
          score = evaluate_board(board)

          # Revert the mock move
          piece.revert_mock_move(from)
          
          # If this move is better than the current best, update the best_move and best_score
          if score > best_score
            best_score = score
            best_move = [from, to]
          end
        end
      end
    end

    return best_move unless best_move.nil?

    # If no valid move is found, return a random move (should not happen in a normal game)
    return pieces.sample.valid_moves.sample
  end

  def evaluate_board(board)
    our_score = 0
    enemy_score = 0

    pieces = board.pieces(@color)
    enemy_pieces = @color == 'white' ? board.pieces('black') : board.pieces('white')

    pieces.each do |piece|
      our_score += piece.score
    end


    enemy_pieces.each do |piece|
      enemy_score += piece.score
    end

    our_score - enemy_score
  end
end
