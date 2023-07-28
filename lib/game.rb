require_relative 'board_builder'
require_relative 'human_player'
require_relative 'ai_player'
require_relative 'smart_ai_player'
require 'sqlite3'

class Game
  # open new game
  def self.new_game(player1, player2)
    Game.new(BoardBuilder.new_board, [player1, player2].shuffle)
  end

  # load saved game
  def self.load_game(id)
    @db = SQLite3::Database.new 'chess.db'
    saved_game = @db.execute('SELECT * FROM games WHERE id = ?', id).first
    if saved_game
      Game.new(Marshal.load(saved_game[1]), Marshal.load(saved_game[2]))
    else
      puts "No game found with id #{id}."
      nil
    end
  end

  def initialize(board, players)
    @board = board
    @players = players
    begin
      @db = SQLite3::Database.new 'chess.db'
    rescue SQLite3::Exception => e
      puts "Database initialization error: #{e}"
    end
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS games (
        id INTEGER PRIMARY KEY,
        board BLOB,
        players BLOB
      );
    SQL
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

      puts from
      if from == 'save'
        save_game
        break
      end

      @board.get_piece(from).move(to)

      @players.rotate!
    end
  end

  def checkmate?(color)
    king = color == 'white' ? @board.white_king : @board.black_king
    in_check = @board.under_attack?(king.location, king.color)
    in_check && @board.saver_pieces(color).empty?
  end

  def save_game
    @db.execute 'INSERT INTO games (board, players) VALUES (?, ?)',
                [Marshal.dump(@board), Marshal.dump(@players)]
    id = @db.last_insert_row_id
    puts "Game saved as #{id}"
  end
end
