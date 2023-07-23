# frozen_string_literal: true

require './lib/board'

describe Knight do
  describe '#valid_moves' do
    it 'returns two squares when on corner' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')

      expect(knight.valid_moves).to eql(Set[[1, 2], [2, 1]])
    end

    it 'returns eight squares when on middle' do
      board = Board.new
      knight = Knight.new(board, [3, 3], 'white')

      expect(knight.valid_moves).to eql(Set[[5, 4], [4, 5], [1, 2], [2, 1], [5, 2], [2, 5], [4, 1], [1, 4]])
    end

    it 'returns none when blocked' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')
      Pawn.new(board, [1, 2], 'white')
      Pawn.new(board, [2, 1], 'black')

      expect(knight.valid_moves).to eql(Set.new)
    end
  end

  describe '#valid_captures' do
    it 'returns empty on empty map' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')

      expect(knight.valid_captures).to eql(Set.new)
    end

    it 'returns a squares when on corner' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')
      Pawn.new(board, [2, 1], 'black')

      expect(knight.valid_captures).to eql(Set[[2, 1]])
    end

    it 'returns eight squares when on center' do
      board = Board.new
      knight = Knight.new(board, [3, 3], 'white')
      Pawn.new(board, [5, 4], 'black')
      Pawn.new(board, [4, 5], 'black')
      Pawn.new(board, [1, 2], 'black')
      Pawn.new(board, [2, 1], 'black')
      Pawn.new(board, [5, 2], 'black')
      Pawn.new(board, [2, 5], 'black')
      Pawn.new(board, [4, 1], 'black')
      Pawn.new(board, [1, 4], 'black')

      expect(knight.valid_captures).to eql(Set[[5, 4], [4, 5], [1, 2], [2, 1], [5, 2], [2, 5], [4, 1], [1, 4]])
    end
  end

  describe '#move' do
    it 'returns false when blocked' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')
      Pawn.new(board, [2, 1], 'white')
      Pawn.new(board, [1, 2], 'white')

      expect(knight.move([2, 1])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(knight)
      expect(knight.move([2, 1])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(knight)
    end

    it 'return false when out of the board' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')

      expect(knight.move([-2, -1])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(knight)
    end

    it 'return false when same place move' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')

      expect(knight.move([0, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(knight)
    end

    it 'return true on move' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')

      expect(knight.move([2, 1])).to eql(true)
      expect(board.get_piece([2, 1])).to eql(knight)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it 'return true on moving multiple times' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')

      expect(knight.move([2, 1])).to eql(true)
      expect(board.get_piece([2, 1])).to eql(knight)
      expect(board.get_piece([0, 0])).to eql(nil)

      expect(knight.move([3, 3])).to eql(true)
      expect(board.get_piece([3, 3])).to eql(knight)
      expect(board.get_piece([2, 1])).to eql(nil)
    end

    it 'return true when capturing' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')
      Pawn.new(board, [2, 1], 'black')

      expect(knight.move([2, 1])).to eql(true)
      expect(board.get_piece([2, 1])).to eql(knight)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it 'return true on multiple capture' do
      board = Board.new
      knight = Knight.new(board, [0, 0], 'white')
      Pawn.new(board, [2, 1], 'black')
      Pawn.new(board, [3, 3], 'black')

      expect(knight.move([2, 1])).to eql(true)
      expect(board.get_piece([2, 1])).to eql(knight)
      expect(board.get_piece([0, 0])).to eql(nil)

      expect(knight.move([3, 3])).to eql(true)
      expect(board.get_piece([3, 3])).to eql(knight)
      expect(board.get_piece([2, 1])).to eql(nil)
    end
  end
end
