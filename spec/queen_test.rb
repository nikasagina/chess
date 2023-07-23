require './lib/board.rb'

describe Queen do
  describe "#valid_moves" do
    it "return aviable squares when on empty board" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")

      expect(queen.valid_moves).to eql(Set[[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
        [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]])
    end

    it "return aviable squares when on empty board middle" do
      board = Board.new
      queen = Queen.new(board, [3, 3], "white")

      expect(queen.valid_moves).to eql(Set[[0, 0], [1, 1], [2, 2], [4, 4], [5, 5], [6, 6], [7, 7],
        [2, 4], [1, 5], [0, 6], [4, 2], [5, 1], [6, 0], [3, 4], [3, 5], [3, 6], [3, 7], [3, 2], [3, 1],
        [3, 0], [0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3]])
    end

    it "return no locations when blocked" do
      board = Board.new
      queen = Queen.new(board, [3, 3], "white")
      Pawn.new(board, [3, 4], 'white')
      Pawn.new(board, [4, 4], 'white')
      Pawn.new(board, [4, 3], 'white')
      Pawn.new(board, [2, 3], 'white')
      Pawn.new(board, [3, 2], 'white')
      Pawn.new(board, [4, 2], 'white')
      Pawn.new(board, [2, 4], 'white')
      Pawn.new(board, [2, 2], 'white')

      expect(queen.valid_moves).to eql(Set.new)
    end
  end

  describe "#valid_captures" do
    it "return empty on no pieces" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "black")

      expect(queen.valid_captures).to eql(Set.new)
    end

    it "return empty when allies" do
      board = Board.new
      queen = Queen.new(board, [3, 3], "white")
      Pawn.new(board, [3, 4], 'white')
      Pawn.new(board, [4, 4], 'white')
      Pawn.new(board, [4, 3], 'white')
      Pawn.new(board, [2, 3], 'white')
      Pawn.new(board, [3, 2], 'white')
      Pawn.new(board, [4, 2], 'white')
      Pawn.new(board, [2, 4], 'white')
      Pawn.new(board, [2, 2], 'white')

      expect(queen.valid_captures).to eql(Set.new)
    end

    it "return eight location when enemy" do
      board = Board.new
      queen = Queen.new(board, [3, 3], "black")
      Pawn.new(board, [0, 3], 'white')
      Pawn.new(board, [7, 3], 'white')
      Pawn.new(board, [3, 0], 'white')
      Pawn.new(board, [3, 7], 'white')
      Pawn.new(board, [0, 0], 'white')
      Pawn.new(board, [7, 7], 'white')
      Pawn.new(board, [0, 6], 'white')
      Pawn.new(board, [6, 0], 'white')

      expect(queen.valid_captures).to eql(Set[[0, 3], [3, 0], [7, 3], [3, 7], [0, 0], [7, 7], [0, 6], [6, 0]])
    end

    it "return one location when enemy is behind enemy" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], 'black')
      Pawn.new(board, [2, 2], 'black')

      expect(queen.valid_captures).to eql(Set[[1, 1]])
    end

    it "return none when enemy is behind ally" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], 'white')
      Pawn.new(board, [2, 2], 'black')

      expect(queen.valid_captures).to eql(Set.new)
    end
  end

  describe "#move" do
    it "return false when blocked" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], "white")

      expect(queen.move([1, 1])).to eql(false)
      expect(queen.move([2, 2])).to eql(false)
      expect(queen.move([7, 7])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(queen)
    end

    it "return false when out of the board" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")

      expect(queen.move([8, 8])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(queen)
    end

    it "return false when same place move" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")

      expect(queen.move([0, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(queen)
    end

    it "return true on move" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")

      expect(queen.move([1, 1])).to eql(true)
      expect(board.get_piece([1, 1])).to eql(queen)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on a multiple square move" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")

      expect(queen.move([3, 3])).to eql(true)
      expect(board.get_piece([3, 3])).to eql(queen)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on a multiple square move black" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "black")

      expect(queen.move([3, 3])).to eql(true)
      expect(board.get_piece([3, 3])).to eql(queen)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on moving multiple times" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")

      expect(queen.move([3, 3])).to eql(true)
      expect(board.get_piece([3, 3])).to eql(queen)
      expect(board.get_piece([0, 0])).to eql(nil)

      expect(queen.move([2, 4])).to eql(true)
      expect(board.get_piece([2, 4])).to eql(queen)
      expect(board.get_piece([3, 3])).to eql(nil)
    end

    it "return false when blocked and trying to jump over" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], "black")

      expect(queen.move([7, 7])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(queen)
      expect(board.get_piece([7, 7])).to eql(nil)
    end

    it "return true when capturing" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")
      Pawn.new(board, [2, 2], "black")

      expect(queen.move([2, 2])).to eql(true)
      expect(board.get_piece([2, 2])).to eql(queen)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on multiple capture" do
      board = Board.new
      queen = Queen.new(board, [0, 0], "white")
      Pawn.new(board, [2, 2], "black")
      Pawn.new(board, [2, 5], "black")

      expect(queen.move([2, 2])).to eql(true)
      expect(board.get_piece([2, 2])).to eql(queen)
      expect(board.get_piece([0, 0])).to eql(nil)

      expect(queen.move([2, 5])).to eql(true)
      expect(board.get_piece([2, 5])).to eql(queen)
      expect(board.get_piece([2, 2])).to eql(nil)
    end
  end
end

