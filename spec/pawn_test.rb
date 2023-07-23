require './lib/board.rb'

describe Pawn do
  describe "#valid_moves" do
    it "return two location on first move black" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")

      expect(pawn.valid_moves).to eql(Set[[1, 0], [2, 0]])
    end

    it "return two location on first move white" do
      board = Board.new
      pawn = Pawn.new(board, [7, 0], "black")

      expect(pawn.valid_moves).to eql(Set[[6, 0], [5, 0]])
    end

    it "return the next square on second move white" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")
      pawn.move [1, 0]

      expect(pawn.valid_moves).to eql(Set[[2, 0]])
    end

    it "return the next square on second move white" do
      board = Board.new
      pawn = Pawn.new(board, [7, 0], "black")
      pawn.move [6, 0]

      expect(pawn.valid_moves).to eql(Set[[5, 0]])
    end

    it "return empty on edge" do
      board = Board.new
      pawn = Pawn.new(board, [7, 0], "white")

      expect(pawn.valid_moves).to eql(Set.new)
    end

    it "return empty when blocked" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")
      Pawn.new(board, [1, 0], "white")

      expect(pawn.valid_moves).to eql(Set.new)
    end
  end

  describe "#valid_captures" do
    it "return empty when no enemies" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")

      expect(pawn.valid_captures).to eql(Set.new)
    end

    it "return empty when ally on attacking squares" do
      board = Board.new
      pawn = Pawn.new(board, [0, 1], "white")
      Pawn.new(board, [1, 0], "white")
      Pawn.new(board, [1, 2], "white")

      expect(pawn.valid_captures).to eql(Set.new)
    end


    it "return the squares when enemy on attacking squares" do
      board = Board.new
      pawn = Pawn.new(board, [0, 1], "white")
      Pawn.new(board, [1, 0], "black")
      Pawn.new(board, [1, 2], "black")

      expect(pawn.valid_captures).to eql(Set[[1, 0], [1, 2]])
    end


    it "return the squares when enemy on attacking squares black" do
      board = Board.new
      pawn = Pawn.new(board, [3, 1], "black")
      Pawn.new(board, [2, 0], "white")
      Pawn.new(board, [2, 2], "white")

      expect(pawn.valid_captures).to eql(Set[[2, 0], [2, 2]])
    end

    it "return a single squares when enemy on attacking square" do
      board = Board.new
      pawn = Pawn.new(board, [0, 1], "white")
      Pawn.new(board, [1, 0], "black")

      expect(pawn.valid_captures).to eql(Set[[1, 0]])
    end

    it "return a single squares when enemy on attacking square black" do
      board = Board.new
      pawn = Pawn.new(board, [3, 1], "black")
      Pawn.new(board, [2, 0], "white")

      expect(pawn.valid_captures).to eql(Set[[2, 0]])
    end
  end

  describe "#move" do
    it "return false when blocked" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")
      Pawn.new(board, [1, 0], "white")

      expect(pawn.move([1, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(pawn)
    end

    it "return false when out of the board" do
      board = Board.new
      pawn = Pawn.new(board, [7, 7], "white")

      expect(pawn.move([8, 7])).to eql(false)
      expect(board.get_piece([7, 7])).to eql(pawn)
    end

    it "return false when same place move" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")

      expect(pawn.move([0, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(pawn)
    end

    it "return true on a single square move" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")

      expect(pawn.move([1, 0])).to eql(true)
      expect(board.get_piece([1, 0])).to eql(pawn)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on a double square move" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")

      expect(pawn.move([2, 0])).to eql(true)
      expect(board.get_piece([2, 0])).to eql(pawn)
      expect(board.get_piece([0, 0])).to eql(nil)
    end

    it "return true on a double square move black" do
      board = Board.new
      pawn = Pawn.new(board, [7, 0], "black")

      expect(pawn.move([5, 0])).to eql(true)
      expect(board.get_piece([5, 0])).to eql(pawn)
      expect(board.get_piece([7, 0])).to eql(nil)
    end

    it "return false when blocked and trying to jump over" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")
      Pawn.new(board, [1, 0], "white")

      expect(pawn.move([2, 0])).to eql(false)
      expect(board.get_piece([0, 0])).to eql(pawn)
      expect(board.get_piece([2, 0])).to eql(nil)
    end

    it "return true when capturing" do
      board = Board.new
      pawn = Pawn.new(board, [0, 0], "white")
      Pawn.new(board, [1, 1], "black")

      expect(pawn.move([1, 1])).to eql(true)
      expect(board.get_piece([1, 1])).to eql(pawn)
      expect(board.get_piece([0, 0])).to eql(nil)
    end
  end
end

