require 'spec_helper'

RSpec.describe Svgcode::SVG::Point do
  describe '.new' do
    context 'when x and y are passed as a comma separated string' do
      let(:point) { Svgcode::SVG::Point.new('100,22.8') }

      it 'parses x to a float' do
        expect(point.x).to eql 100.0
      end

      it 'parses y to a float' do
        expect(point.y).to eql 22.8
      end
    end

    context 'when x and y are passed as separate strings' do
      let(:point) { Svgcode::SVG::Point.new('5', '18.2222') }

      it 'parses x to a float' do
        expect(point.x).to eql 5.0
      end

      it 'parses y to a float' do
        expect(point.y).to eql 18.2222
      end
    end

    context 'when x and y are passed as floats' do
      let(:point) { Svgcode::SVG::Point.new(17.23, 16.2) }

      it 'sets x' do
        expect(point.x).to eql 17.23
      end

      it 'sets y' do
        expect(point.y).to eql 16.2
      end
    end
  end

  describe '#==' do
    let(:a) { Svgcode::SVG::Point.new(5, 6) }

    context 'when x and y are the same' do
      let(:b) { Svgcode::SVG::Point.new(5, 6) }

      it 'returns true' do
        expect(a == b).to be true
      end
    end

    context 'when x differs' do
      let(:b) { Svgcode::SVG::Point.new(5.8, 6) }

      it 'returns false' do
        expect(a == b).to be false
      end
    end

    context 'when y differs' do
      let(:b) { Svgcode::SVG::Point.new(5, 17) }

      it 'returns false' do
        expect(a == b).to be false
      end
    end
  end

  describe '#negate_y' do
    context 'when y is 0' do
      let(:point) { Svgcode::SVG::Point.new(10, 0) }

      it 'returns a new point equal to the original' do
        expect(point.negate_y).to eq point
      end
    end

    context 'when y is positive' do
      let(:point) { Svgcode::SVG::Point.new(0, 15.80) }

      it 'returns a new point with a negative y value' do
        expect(point.negate_y).to eq Svgcode::SVG::Point.new(0, -15.80)
      end
    end

    context 'when y is negative' do
      let(:point) { Svgcode::SVG::Point.new(-2.2, -15) }

      it 'returns a new point with a positive y value' do
        expect(point.negate_y).to eq Svgcode::SVG::Point.new(-2.2, 15)
      end
    end
  end

  describe '#negate_y!' do
    context 'when y is positive' do
      let(:point) do
        point = Svgcode::SVG::Point.new(0, 15.80)
        point.negate_y!
        point
      end

      it 'negates the y value in place' do
        expect(point).to eq Svgcode::SVG::Point.new(0, -15.80)
      end
    end
  end

  describe '#relative' do
    context 'when another point is passed' do
      let(:point) do
        pt = Svgcode::SVG::Point.new(3.7, 16.233)
        pt.relative(Svgcode::SVG::Point.new(-1.1, 5))
      end

      it 'returns a new point with x and y values the sum of self and other' do
        expect(point).to eq Svgcode::SVG::Point.new(2.6, 21.233)
      end
    end
  end

  skip '#/'

  skip '#divide_by!'

  skip '#flip_y!'

  skip '#+'

  describe '.parse' do
    context 'when a string containing space separated point values is passed' do
      let(:points) { Svgcode::SVG::Point.parse('7.3,160.23 8.0,15.65') }

      it 'returns an array of point objects' do
        expect(points).to eq [
          Svgcode::SVG::Point.new(7.3, 160.23),
          Svgcode::SVG::Point.new(8.0, 15.65)
        ]
      end
    end

    context 'when a string containing a single point value is passed' do
      let(:points) { Svgcode::SVG::Point.parse('5.11,1.0') }

      it 'returns an array containing a single point object' do
        expect(points).to eq [Svgcode::SVG::Point.new(5.11, 1.0)]
      end
    end

    context 'when the second point has negative values' do
      let(:points) { Svgcode::SVG::Point.parse('5.11,1.0 -52,-56.9') }

      it 'returns an array of point objects' do
        expect(points).to eq [
          Svgcode::SVG::Point.new(5.11, 1.0),
          Svgcode::SVG::Point.new(-52.0, -56.9)
        ]
      end
    end
  end
end
