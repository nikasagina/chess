# frozen_string_literal: true

require_relative 'board_builder'
require_relative 'human_player'
require_relative 'ai_player'
require_relative 'smart_ai_player'

class Main
  def initialize(player1, player2)
    @board = BoardBuilder.new_board
    @players = [player1, player2].shuffle
  end

  def run
    loop do
      current_player = @players.first

      if checkmate?(current_player.color)
        puts "#{@current_player.color} has lost the game. checkmate"
        break
      end

      puts @board

      from, to = current_player.next_move(@board)

      @board.get_piece(from).move(to)

      @players.rotate!
    end
  end

  def checkmate?(color)
    king = color == 'white' ? @board.white_king : @board.black_king
    in_check = @board.under_attack?(king.location, king.color)
    return in_check && @board.saver_pieces(color).empty?
  end
end

Main.new(HumanPlayer.new('white'), SmartAiPlayer.new('black')).run
