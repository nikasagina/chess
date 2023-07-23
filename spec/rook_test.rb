require './lib/board.rb'

describe Rook do
  describe "#valid_moves" do
    it "return all 15 locations corner" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")

      expect(rook.valid_moves).to eql(Set[[1, 0], [2, 0], [3, 0], [4, 0], [5, 0],
         [6, 0], [7, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]])
    end

    it "return all 15 locations corner black" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "black")

      expect(rook.valid_moves).to eql(Set[[1, 0], [2, 0], [3, 0], [4, 0], [5, 0],
         [6, 0], [7, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]])
    end

    it "return all 15 locations center" do
      board = Board.new
      rook = Rook.new(board, [4, 4], "white")

      expect(rook.valid_moves).to eql(Set[[4, 0], [4, 1], [4, 2], [4, 3], [4, 5],
         [4, 6], [4, 7], [0, 4], [1, 4], [2, 4], [3, 4], [5, 4], [6, 4], [7, 4]])
    end

    it "return no locations when blocked" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "black")
      Pawn.new(board, [1, 0], 'white')
      Pawn.new(board, [0, 1], 'white')

      expect(rook.valid_moves).to eql(Set.new)
    end
  end

  describe "#valid_captures" do
    it "return empty on no pieces" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")

      expect(rook.valid_captures).to eql(Set.new)
    end

    it "return empty when allies" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")
      Pawn.new(board, [1, 0], 'white')
      Pawn.new(board, [0, 1], 'white')

      expect(rook.valid_captures).to eql(Set.new)
    end

    it "return two locations when surrounded" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")
      Pawn.new(board, [1, 0], 'black')
      Pawn.new(board, [0, 1], 'black')

      expect(rook.valid_captures).to eql(Set[[1, 0], [0, 1]])
    end

    it "return one location when enemy is behind enemy" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")
      Pawn.new(board, [5, 0], 'black')
      Pawn.new(board, [6, 0], 'black')

      expect(rook.valid_captures).to eql(Set[[5, 0]])
    end

    it "return none when enemy is behind ally" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")
      Pawn.new(board, [5, 0], 'white')
      Pawn.new(board, [6, 0], 'black')

      expect(rook.valid_captures).to eql(Set.new)
    end

    it "return four location when surrounded in senter" do
      board = Board.new
      rook = Rook.new(board, [4, 4], "white")
      Pawn.new(board, [5, 4], 'black')
      Pawn.new(board, [4, 5], 'black')
      Pawn.new(board, [3, 4], 'black')
      Pawn.new(board, [4, 3], 'black')

      expect(rook.valid_captures).to eql(Set[[5, 4], [4, 5], [3, 4], [4, 3]])
    end
  end

  describe "#move" do
    it "return false when blocked" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")
      Pawn.new(board, [1, 0], "white")

      expect(rook.move([1, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(rook)
    end

    it "return false when out of the board" do
      board = Board.new
      rook = Rook.new(board, [7, 7], "white")

      expect(rook.move([8, 7])).to eql(false)
      expect(board.get_piece([7, 7])).to eql(rook)
    end

    it "return false when same place move" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")

      expect(rook.move([0, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(rook)
    end

    it "return true on a single square move" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")

      expect(rook.move([1, 0])).to eql(true)
      expect(board.get_piece([1, 0])).to eql(rook)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on a multiple square move" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")

      expect(rook.move([7, 0])).to eql(true)
      expect(board.get_piece([7, 0])).to eql(rook)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on a multiple square move black" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "black")

      expect(rook.move([7, 0])).to eql(true)
      expect(board.get_piece([7, 0])).to eql(rook)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return false when blocked and trying to jump over" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "black")
      Pawn.new(board, [1, 0], "black")

      expect(rook.move([7, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(rook)
      expect(board.get_piece([7, 0])).to eql(nil)
    end

    it "return true when capturing" do
      board = Board.new
      rook = Rook.new(board, [0, 0], "white")
      Pawn.new(board, [1, 0], "black")

      expect(rook.move([1, 0])).to eql(true)
      expect(board.get_piece([1, 0])).to eql(rook)
      expect(board.get_piece([0, 0])).to eql(nil)
    end
  end
end

