require 'spec_helper'

RSpec.describe Svgcode::SVG::Point do
  describe '.new' do
    context 'when X and Y are passed as a comma separated string' do
      let(:point) { Svgcode::SVG::Point.new('100,22.8') }

      it 'parses X to a float' do
        expect(point.x).to eql 100.0
      end

      it 'parses Y to a float' do
        expect(point.y).to eql 22.8
      end
    end

    context 'when X and Y are passed as separate strings' do
      let(:point) { Svgcode::SVG::Point.new('5', '18.2222') }

      it 'parses X to a float' do
        expect(point.x).to eql 5.0
      end

      it 'parses Y to a float' do
        expect(point.y).to eql 18.2222
      end
    end

    context 'when X and Y are passed as floats' do
      let(:point) { Svgcode::SVG::Point.new(17.23, 16.2) }

      it 'sets X' do
        expect(point.x).to eql 17.23
      end

      it 'sets Y' do
        expect(point.y).to eql 16.2
      end
    end
  end

  describe '#==' do
    let(:a) { Svgcode::SVG::Point.new(5, 6) }

    context 'when both points have the same value for X and Y' do
      let(:b) { Svgcode::SVG::Point.new(5, 6) }

      it 'returns true' do
        expect(a == b).to be true
      end
    end

    context "when the points' X values differ" do
      let(:b) { Svgcode::SVG::Point.new(5.8, 6) }

      it 'returns false' do
        expect(a == b).to be false
      end
    end

    context "when the points' Y values differ" do
      let(:b) { Svgcode::SVG::Point.new(5, 17) }

      it 'returns false' do
        expect(a == b).to be false
      end
    end
  end

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
  end
end
