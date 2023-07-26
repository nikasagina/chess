# frozen_string_literal: true

require './lib/board'

describe King do
  describe '#valid_moves' do
    it 'returns three squares when on corner' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')

      expect(king.valid_moves).to eql(Set[[1, 0], [0, 1], [1, 1]])
    end

    it 'returns eight squares when on middle' do
      board = Board.new
      king = King.new(board, [3, 3], 'white')

      expect(king.valid_moves).to eql(Set[[4, 4], [3, 4], [4, 3], [2, 3], [3, 2], [2, 2], [2, 4], [4, 2]])
    end

    it 'returns none when blocked' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      Pawn.new(board, [1, 1], 'white')
      Pawn.new(board, [1, 0], 'white')
      Pawn.new(board, [0, 1], 'black')

      expect(king.valid_moves).to eql(Set.new)
    end
  end

  describe '#valid_captures' do
    it 'returns empty on empty map' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')

      expect(king.valid_captures).to eql(Set.new)
    end

    it 'returns a single when on corner with pawn' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      Pawn.new(board, [1, 1], 'black')

      expect(king.valid_captures).to eql(Set[[1, 1]])
    end

    it 'returns undefended pawns' do
      board = Board.new
      king = King.new(board, [3, 3], 'white')
      Pawn.new(board, [4, 4], 'black')
      Pawn.new(board, [5, 5], 'black') # defends pawn above
      Pawn.new(board, [4, 3], 'black')

      expect(king.valid_captures).to eql(Set[[4, 3]])
    end

    it 'returns none when surrounded with queens' do
      board = Board.new
      king = King.new(board, [3, 3], 'white')
      Queen.new(board, [4, 4], 'black')
      Queen.new(board, [3, 4], 'black')
      Queen.new(board, [4, 3], 'black')
      Queen.new(board, [2, 3], 'black')
      Queen.new(board, [3, 2], 'black')
      Queen.new(board, [2, 2], 'black')
      Queen.new(board, [4, 2], 'black')
      Queen.new(board, [2, 4], 'black')

      expect(king.valid_captures).to eql(Set.new)
    end
  end

  describe '#move' do
    it 'return false when out of the board' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')

      expect(king.move([-2, -1])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(king)
    end

    it 'returns false when defended' do
      board = Board.new
      king = King.new(board, [0, 0], 'black')
      Pawn.new(board, [1, 1], 'white')
      Pawn.new(board, [0, 2], 'white') # defends pawn above

      expect(king.move([1, 1])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(king)
      expect(king.move([2, 1])).to eql(false)
    end

    it 'return false when same place move' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')

      expect(king.move([0, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(king)
    end

    it 'return true on move' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')

      expect(king.move([1, 1])).to eql(true)
      expect(board.get_piece([1, 1])).to eql(king)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it 'return true on moving multiple times' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')

      expect(king.move([0, 1])).to eql(true)
      expect(board.get_piece([0, 1])).to eql(king)
      expect(board.get_piece([0, 0])).to eql(nil)

      expect(king.move([0, 2])).to eql(true)
      expect(board.get_piece([0, 2])).to eql(king)
      expect(board.get_piece([0, 1])).to eql(nil)
    end

    it 'return true when capturing' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      Pawn.new(board, [1, 1], 'black')

      expect(king.move([1, 1])).to eql(true)
      expect(board.get_piece([1, 1])).to eql(king)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it 'return true on multiple capture' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      Pawn.new(board, [1, 1], 'black')
      Knight.new(board, [2, 2], 'black')

      expect(king.move([1, 1])).to eql(true)
      expect(board.get_piece([1, 1])).to eql(king)
      expect(board.get_piece([0, 0])).to eql(nil)

      expect(king.move([2, 2])).to eql(true)
      expect(board.get_piece([2, 2])).to eql(king)
      expect(board.get_piece([1, 1])).to eql(nil)
    end
  end

  describe '#castle' do
    it 'return false only king' do
      board = Board.new
      king = King.new(board, [0, 4], 'white')

      expect(king.castle(:kingside)).to eql(false)
      expect(king.castle(:queenside)).to eql(false)
    end

    it 'return false when king moved' do
      board = Board.new
      king = King.new(board, [0, 4], 'white')
      king.move([0, 3])
      king.move([0, 4])
      Rook.new(board, [0, 0], 'white')

      expect(king.castle(:kingside)).to eql(false)
      expect(king.castle(:queenside)).to eql(false)
    end

    it 'return false when rook moved' do
      board = Board.new
      king = King.new(board, [0, 4], 'white')

      rook = Rook.new(board, [0, 0], 'white')
      rook.move([0, 1])
      rook.move([0, 0])

      expect(king.castle(:kingside)).to eql(false)
      expect(board.get_piece([0, 4])).to eql(king)
      expect(board.get_piece([0, 0])).to eql(rook)
    end

    it 'return true when caslte aviable' do
      board = Board.new
      king = King.new(board, [0, 4], 'white')
      rook = Rook.new(board, [0, 0], 'white')

      expect(king.castle(:queenside)).to eql(true)
      expect(board.get_piece([0, 2])).to eql(king)
      expect(board.get_piece([0, 3])).to eql(rook)
    end

    it 'return false when caslte is blocked' do
      board = Board.new
      king = King.new(board, [0, 4], 'white')
      rook = Rook.new(board, [0, 0], 'white')
      Queen.new(board, [7, 2], 'black')

      expect(king.castle(:queenside)).to eql(false)
      expect(board.get_piece([0, 4])).to eql(king)
      expect(board.get_piece([0, 0])).to eql(rook)
    end
  end
end
