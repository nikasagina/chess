# frozen_string_literal: true

require './lib/board'

describe Board do
  describe '#under_attack?' do
    it 'returns false on empty board' do
      board = Board.new
      8.times do |row|
        8.times do |col|
          expect(board.under_attack?([row, col], 'white')).to eql(false)
          expect(board.under_attack?([row, col], 'black')).to eql(false)
        end
      end
    end

    it 'knight attacks' do
      board = Board.new
      knight = Knight.new(board, [3, 3], 'white')

      expect(board.under_attack?([1, 2], 'black')).to eql(true)
      expect(board.under_attack?([4, 5], 'black')).to eql(true)
      expect(board.under_attack?([1, 2], 'white')).to eql(false)
      expect(board.under_attack?([4, 5], 'white')).to eql(false)
      expect(board.under_attack?([2, 2], 'black')).to eql(false)
    end

    it 'rook attacks' do
      board = Board.new
      rook = Rook.new(board, [0, 0], 'white')

      expect(board.under_attack?([0, 5], 'black')).to eql(true)
      expect(board.under_attack?([0, 6], 'black')).to eql(true)
      expect(board.under_attack?([0, 2], 'white')).to eql(false)
      expect(board.under_attack?([2, 2], 'white')).to eql(false)
      expect(board.under_attack?([2, 2], 'black')).to eql(false)
    end

    it 'bishop attacks' do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], 'white')

      expect(board.under_attack?([5, 5], 'black')).to eql(true)
      expect(board.under_attack?([2, 2], 'black')).to eql(true)
      expect(board.under_attack?([3, 3], 'white')).to eql(false)
      expect(board.under_attack?([1, 1], 'white')).to eql(false)
      expect(board.under_attack?([2, 3], 'black')).to eql(false)
    end

    it 'queen attacks' do
      board = Board.new
      queen = Queen.new(board, [0, 0], 'white')

      expect(board.under_attack?([5, 5], 'black')).to eql(true)
      expect(board.under_attack?([0, 5], 'black')).to eql(true)
      expect(board.under_attack?([3, 3], 'white')).to eql(false)
      expect(board.under_attack?([1, 1], 'white')).to eql(false)
      expect(board.under_attack?([2, 3], 'black')).to eql(false)
    end

    it 'pawn attacks' do
      board = Board.new
      pawn = Pawn.new(board, [0, 1], 'white')

      expect(board.under_attack?([1, 0], 'black')).to eql(true)
      expect(board.under_attack?([1, 2], 'black')).to eql(true)
      expect(board.under_attack?([1, 0], 'white')).to eql(false)
      expect(board.under_attack?([1, 1], 'white')).to eql(false)
      expect(board.under_attack?([1, 1], 'black')).to eql(false)
    end

    it 'king attacks' do
      board = Board.new
      king = King.new(board, [0, 1], 'white')

      expect(board.under_attack?([0, 0], 'black')).to eql(true)
      expect(board.under_attack?([1, 2], 'black')).to eql(true)
      expect(board.under_attack?([1, 0], 'white')).to eql(false)
      expect(board.under_attack?([1, 1], 'white')).to eql(false)
      expect(board.under_attack?([4, 5], 'black')).to eql(false)
    end
  end
end
