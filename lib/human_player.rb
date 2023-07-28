# frozen_string_literal: true

require_relative 'player'
require_relative 'coords_converter'

class HumanPlayer < Player
  def next_move(board)
    loop do
      move = read_whole(board)

      if move.nil?
        puts 'Invalid move, please try again'
        next
      end

      return move
    end
  end

  private

  def read_whole(board)
    puts "It is #{@color}'s turn. Enter your move (e.g., 'e2 e4'):"
    input = gets.chomp
    return [input, nil] if input == 'save'

    parts = input.split(' ')

    return nil if parts.size != 2

    from = CoordsConverter.to_internal(parts[0])
    to = CoordsConverter.to_internal(parts[1])

    return nil unless MoveValidator.valid_move?(board, from, to, @color)

    [from, to]
  end

  def read_parts(board)
    puts "It is #{@color}'s turn. Enter the square of the piece you want to move (e.g., 'e2'):"
    from = CoordsConverter.to_internal(gets.chomp)
    return nil unless MoveValidator.valid_from?(board, from, @color)

    puts "Enter a square you want the piece to move (e.g., 'e2'):"
    to = CoordsConverter.to_internal(gets.chomp)
    return nil unless MoveValidator.valid_to?(board, to, from, @color)

    [from, to]
  end
end
