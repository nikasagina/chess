require './lib/board.rb'

describe Bishop do
  describe "#valid_moves" do
    it "return main diagonal when on corner" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")

      expect(bishop.valid_moves).to eql(Set[[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]])
    end

    it "return all locations when on middle" do
      board = Board.new
      bishop = Bishop.new(board, [4, 4], "white")

      expect(bishop.valid_moves).to eql(Set[[5, 5], [6, 6], [7, 7], [3, 3], [2, 2],
         [1, 1], [0, 0], [5, 3], [6, 2], [7, 1], [3, 5], [2, 6], [1, 7]])
    end

    it "return no locations when blocked" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "black")
      Pawn.new(board, [1, 1], 'white')

      expect(bishop.valid_moves).to eql(Set.new)
    end
  end

  describe "#valid_captures" do
    it "return empty on no pieces" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "black")

      expect(bishop.valid_captures).to eql(Set.new)
    end

    it "return empty when allies" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], 'white')

      expect(bishop.valid_captures).to eql(Set.new)
    end

    it "return one location when enemy" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], 'black')

      expect(bishop.valid_captures).to eql(Set[[1, 1]])
    end

    it "return four locations when surrounded" do
      board = Board.new
      bishop = Bishop.new(board, [3, 3], "white")
      Pawn.new(board, [4, 4], 'black')
      Pawn.new(board, [2, 2], 'black')
      Pawn.new(board, [2, 4], 'black')
      Pawn.new(board, [4, 2], 'black')

      expect(bishop.valid_captures).to eql(Set[[4, 4], [2, 2], [2, 4], [4, 2]])
    end

    it "return one location when enemy is behind enemy" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], 'black')
      Pawn.new(board, [2, 2], 'black')

      expect(bishop.valid_captures).to eql(Set[[1, 1]])
    end

    it "return none when enemy is behind ally" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], 'white')
      Pawn.new(board, [2, 2], 'black')

      expect(bishop.valid_captures).to eql(Set.new)
    end
  end

  describe "#move" do
    it "return false when blocked" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], "white")

      expect(bishop.move([1, 1])).to eql(false)
      expect(bishop.move([2, 2])).to eql(false)
      expect(bishop.move([7, 7])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(bishop)
    end

    it "return false when out of the board" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")

      expect(bishop.move([8, 8])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(bishop)
    end

    it "return false when same place move" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")

      expect(bishop.move([0, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(bishop)
    end

    it "return true on move" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")

      expect(bishop.move([1, 1])).to eql(true)
      expect(board.get_piece([1, 1])).to eql(bishop)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on a multiple square move" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")

      expect(bishop.move([3, 3])).to eql(true)
      expect(board.get_piece([3, 3])).to eql(bishop)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on a multiple square move black" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "black")

      expect(bishop.move([3, 3])).to eql(true)
      expect(board.get_piece([3, 3])).to eql(bishop)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on moving multiple times" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")

      expect(bishop.move([3, 3])).to eql(true)
      expect(board.get_piece([3, 3])).to eql(bishop)
      expect(board.get_piece([0, 0])).to eql(nil)

      expect(bishop.move([2, 4])).to eql(true)
      expect(board.get_piece([2, 4])).to eql(bishop)
      expect(board.get_piece([3, 3])).to eql(nil)
    end

    it "return false when blocked and trying to jump over" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], "black")

      expect(bishop.move([7, 7])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(bishop)
      expect(board.get_piece([7, 7])).to eql(nil)
    end

    it "return true when capturing" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")
      Pawn.new(board, [2, 2], "black")

      expect(bishop.move([2, 2])).to eql(true)
      expect(board.get_piece([2, 2])).to eql(bishop)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on multiple capture" do
      board = Board.new
      bishop = Bishop.new(board, [0, 0], "white")
      Pawn.new(board, [2, 2], "black")
      Pawn.new(board, [5, 5], "black")

      expect(bishop.move([2, 2])).to eql(true)
      expect(board.get_piece([2, 2])).to eql(bishop)
      expect(board.get_piece([0, 0])).to eql(nil)

      expect(bishop.move([5, 5])).to eql(true)
      expect(board.get_piece([5, 5])).to eql(bishop)
      expect(board.get_piece([2, 2])).to eql(nil)
    end
  end
end

