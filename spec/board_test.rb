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

  describe '#pieces' do
    it 'return empty' do
      board = Board.new

      expect(board.pieces('white')).to eql([])
      expect(board.pieces('black')).to eql([])
    end

    it 'return a pawn' do
      board = Board.new
      white_pawn = Pawn.new(board, [0, 0], 'white')
      black_pawn = Pawn.new(board, [2, 2], 'black')

      expect(board.pieces('white')).to eql([white_pawn])
      expect(board.pieces('black')).to eql([black_pawn])
    end

    it 'return multiple pieces' do
      board = Board.new
      white_pawn = Pawn.new(board, [0, 0], 'white')
      black_pawn = Pawn.new(board, [2, 2], 'black')
      king = King.new(board, [4, 4], 'white')
      bishop = Bishop.new(board, [3, 3], 'white')

      expect(board.pieces('white')).to eql([white_pawn, bishop, king])
      expect(board.pieces('black')).to eql([black_pawn])
    end
  end

  describe '#attacking_pieces' do
    it 'return empty' do
      board = Board.new
      Pawn.new(board, [0, 0], 'white')

      expect(board.attacking_pieces([0, 0], 'white')).to eql(Set.new)
      expect(board.attacking_pieces([1, 1], 'white')).to eql(Set.new)
    end

    it 'return a pawn' do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], 'white')
      Pawn.new(board, [1, 1], 'black')

      expect(board.attacking_pieces([1, 1], 'black')).to eql(Set[pawn.location])
    end


    it 'return multiple' do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], 'white')
      bishop = Bishop.new(board, [0, 2], 'white')
      Pawn.new(board, [1, 1], 'black')

      expect(board.attacking_pieces([1, 1], 'black')).to eql(Set[pawn.location, bishop.location])
    end
  end

  describe '#saver_pieces' do
    it 'return empty when checkmate' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      board.set_white_king(king)

      Queen.new(board, [1, 1], 'black')
      Queen.new(board, [2, 2], 'black')

      expect(board.under_attack?(king.location, king.color)).to eql(true)
      expect(board.saver_pieces('white')).to eql(Set.new)
    end

    it 'return king when it can move' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      board.set_white_king(king)

      Bishop.new(board, [5, 5], 'black')

      expect(board.under_attack?(king.location, king.color)).to eql(true)
      expect(board.saver_pieces('white')).to eql(Set[king])
    end

    it 'return king when it kill attacker' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      board.set_white_king(king)

      Bishop.new(board, [1, 1], 'black')

      expect(board.under_attack?(king.location, king.color)).to eql(true)
      expect(board.saver_pieces('white')).to eql(Set[king])
    end

    it 'return bishop when it can block' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      board.set_white_king(king)

      Queen.new(board, [5, 5], 'black')

      bishop = Bishop.new(board, [0, 2], 'white')

      expect(board.under_attack?(king.location, king.color)).to eql(true)
      expect(board.saver_pieces('white')).to eql(Set[king, bishop])
    end

    it 'return bishop when it can kill attacker' do
      board = Board.new
      king = King.new(board, [0, 0], 'white')
      board.set_white_king(king)

      Queen.new(board, [5, 5], 'black')

      bishop = Bishop.new(board, [6, 6], 'white')

      expect(board.under_attack?(king.location, king.color)).to eql(true)
      expect(board.saver_pieces('white')).to eql(Set[king, bishop])
    end
  end
end
