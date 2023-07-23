require_relative "board_builder"

board = BoardBuilder.new_board

puts board

puts board.get_piece([1, 1]).valid_moves
