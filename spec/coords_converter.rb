# frozen_string_literal: true

require './lib/coords_converter'

describe CoordsConverter do
  describe '#to_chess_standard' do
    it 'converts row/col to chess notation' do
      expect(CoordsConverter.to_chess_standard([0, 4])).to eql('e1')
      expect(CoordsConverter.to_chess_standard([7, 3])).to eql('d8')
      expect(CoordsConverter.to_chess_standard([3, 0])).to eql('a4')
      expect(CoordsConverter.to_chess_standard([0, 1])).to eql('b1')
    end

    it 'returns nil for invalid entrie' do
      expect(CoordsConverter.to_chess_standard([8, 4])).to be_nil
      expect(CoordsConverter.to_chess_standard([0, 8])).to be_nil
      expect(CoordsConverter.to_chess_standard([-1, 3])).to be_nil
    end
  end

  describe '#to_internal' do
    it 'converts chess notation to row/col' do
      expect(CoordsConverter.to_internal('e1')).to eql([0, 4])
      expect(CoordsConverter.to_internal('d8')).to eql([7, 3])
      expect(CoordsConverter.to_internal('a4')).to eql([3, 0])
      expect(CoordsConverter.to_internal('b1')).to eql([0, 1])
    end

    it 'returns nil for invalid chess notation' do
      expect(CoordsConverter.to_internal('i5')).to be_nil
      expect(CoordsConverter.to_internal('a9')).to be_nil
      expect(CoordsConverter.to_internal('B3')).to be_nil
      expect(CoordsConverter.to_internal('e0')).to be_nil
    end
  end
end
