# frozen_string_literal: true

require_relative 'player'
require_relative 'coords_converter.rb'

class HumanPlayer < Player
  def next_move(board)
    loop do
      move = read_parts(board)

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
    parts = input.split(' ')

    return nil if parts.size != 2

    from = CoordsConverter.to_internal(parts[0])
    to = CoordsConverter.to_internal(parts[1])

    return nil unless MoveValidator.valid_move?(board, from, to, @color)

    return [from, to]
  end

  def read_parts(board)
    puts "It is #{@color}'s turn. Enter the square of the piece you want to move (e.g., 'e2'):"
    from = CoordsConverter.to_internal(gets.chomp)
    return nil unless MoveValidator.valid_from?(board, from, @color)


    puts "Enter a square you want the piece to move (e.g., 'e2'):"
    to = CoordsConverter.to_internal(gets.chomp)
    return nil unless MoveValidator.valid_to?(board, to, from, @color)

    return [from, to]
  end
end
