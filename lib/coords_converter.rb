# frozen_string_literal: true

class CoordsConverter
  FILE_MAP = {
    0 => 'a',
    1 => 'b',
    2 => 'c',
    3 => 'd',
    4 => 'e',
    5 => 'f',
    6 => 'g',
    7 => 'h'
  }.freeze

  def self.to_chess_standard(location)
    return nil unless location.is_a?(Array) && location.length == 2

    row, col = location
    return nil unless row.between?(0, 7) && col.between?(0, 7)

    file = FILE_MAP[col]
    rank = row + 1

    "#{file}#{rank}"
  end

  def self.to_internal(coord)
    return nil unless coord.match?(/^[a-h][1-8]$/)

    row = coord[1].to_i - 1
    col = FILE_MAP.invert[coord[0]]

    [row, col]
  end
end
