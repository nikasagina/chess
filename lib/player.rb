# frozen_string_literal: true

require_relative 'board'
require_relative 'move_validator'

class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def next_move(board)
    raise NotImplementedError
  end
end
