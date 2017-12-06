require 'spec_helper'

module Svgcode
  module SVG
    RSpec.describe Point do
      describe '.new' do
        context 'when x and y are passed as a comma separated string' do
          let(:point) { Point.new('100,22.8') }

          it 'parses x to a float' do
            expect(point.x).to eql 100.0
          end

          it 'parses y to a float' do
            expect(point.y).to eql 22.8
          end
        end

        context 'when x and y are passed as separate strings' do
          let(:point) { Point.new('5', '18.2222') }

          it 'parses x to a float' do
            expect(point.x).to eql 5.0
          end

          it 'parses y to a float' do
            expect(point.y).to eql 18.2222
          end
        end

        context 'when x and y are passed as floats' do
          let(:point) { Point.new(17.23, 16.2) }

          it 'sets x' do
            expect(point.x).to eql 17.23
          end

          it 'sets y' do
            expect(point.y).to eql 16.2
          end
        end
      end

      describe '#==' do
        let(:a) { Point.new(5, 6) }

        context 'when x and y are the same' do
          let(:b) { Point.new(5, 6) }

          it 'returns true' do
            expect(a == b).to be true
          end
        end

        context 'when x differs' do
          let(:b) { Point.new(5.8, 6) }

          it 'returns false' do
            expect(a == b).to be false
          end
        end

        context 'when y differs' do
          let(:b) { Point.new(5, 17) }

          it 'returns false' do
            expect(a == b).to be false
          end
        end
      end

      describe '#negate_y' do
        context 'when y is 0' do
          let(:point) { Point.new(10, 0) }

          it 'returns a new point equal to the original' do
            expect(point.negate_y).to eq point
          end
        end

        context 'when y is positive' do
          let(:point) { Point.new(0, 15.80) }

          it 'returns a new point with a negative y value' do
            expect(point.negate_y).to eq Point.new(0, -15.80)
          end
        end

        context 'when y is negative' do
          let(:point) { Point.new(-2.2, -15) }

          it 'returns a new point with a positive y value' do
            expect(point.negate_y).to eq Point.new(-2.2, 15)
          end
        end
      end

      describe '#negate_y!' do
        context 'when y is positive' do
          let(:point) do
            point = Point.new(0, 15.80)
            point.negate_y!
            point
          end

          it 'negates the y value in place' do
            expect(point).to eq Point.new(0, -15.80)
          end
        end
      end

      describe '#+' do
        let(:point) { Point.new(1, 1) }

        context 'when other is a point' do
          let(:other) { Point.new(5, 21.808) }

          it 'returns a new point with the x and ys added' do
            result = point + other
            expect(result).to eq Point.new(6, 22.808)
          end
        end

        context 'when other is a number' do
          let(:other) { -18.80 }

          it 'returns a new point with the amount added to x and y' do
            result = point + other
            expect(result).to eq Point.new(-17.8, -17.8)
          end
        end
      end

      skip '#-'

      skip '#*'

      describe '#/' do
        let(:point) { Point.new(16, 8) }

        context 'when other is a point' do
          let(:other) { Point.new(4, 4) }

          it "returns a new point with x and y divided by the other point's" do
            result = point / other
            expect(result).to eq Point.new(4, 2)
          end
        end

        context 'when other is a number' do
          let(:other) { 8 }

          it 'returns a new point with x and y divided by the amount' do
            result = point / other
            expect(result).to eq Point.new(2, 1)
          end
        end
      end

      describe '#divide_by!' do
        context 'when the amount is not 0' do
          let(:point) { Point.new(55.5, 120) }
          let(:amount) { 5.0 }

          it 'divides the points x and y by the amount in place' do
            point.divide_by!(amount)
            expect(point).to eq Point.new(11.1, 24)
          end
        end
      end

      describe '#flip_y!' do
        let(:point) { Point.new(202.8, 5.222) }
        let(:max_y) { 1800 }

        it 'sets y to max_y - y' do
          point.flip_y!(max_y)
          expect(point.y).to eq 1794.778
        end
      end

      describe '.parse' do
        context 'when a string containing space separated point values is passed' do
          let(:points) { Point.parse('7.3,160.23 8.0,15.65') }

          it 'returns an array of point objects' do
            expect(points).to eq [
              Point.new(7.3, 160.23),
              Point.new(8.0, 15.65)
            ]
          end
        end

        context 'when a string containing a single point value is passed' do
          let(:points) { Point.parse('5.11,1.0') }

          it 'returns an array containing a single point object' do
            expect(points).to eq [Point.new(5.11, 1.0)]
          end
        end

        context 'when the second point has negative values' do
          let(:points) { Point.parse('5.11,1.0 -52,-56.9') }

          it 'returns an array of point objects' do
            expect(points).to eq [
              Point.new(5.11, 1.0),
              Point.new(-52.0, -56.9)
            ]
          end
        end
      end
    end
  end
end
