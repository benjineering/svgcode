require 'spec_helper'

module Svgcode
  module SVG
    RSpec.describe Transform do
      describe '.new' do
        context 'when a matrix transform string is passed' do
          let(:transform) do
            Transform.new(
              'matrix(-0.0171558,0.0640262,-0.0640262,'\
              '-0.0171558,358.833,456.823)'
            )
          end

          it 'sets a' do
            expect(transform.a).to eq -0.017
          end

          it 'sets b' do
            expect(transform.b).to eq 0.064
          end

          it 'sets c' do
            expect(transform.c).to eq -0.064
          end

          it 'sets d' do
            expect(transform.d).to eq -0.017
          end

          it 'sets e' do
            expect(transform.e).to eq 358.833
          end

          it 'sets f' do
            expect(transform.f).to eq 456.823
          end
        end
      end

      describe '#apply' do
        context 'when a point is passed' do
          let(:point) { Point.new(3, 5) }
          let(:transform) { Transform.new('matrix(1, 0, 0, 1, 1.1, 5)') }

          it 'returns a new point with the transform applied' do
            expect(transform.apply(point)).to eq Point.new(4.1, 10)
          end
        end
      end

      skip '#to_matrix'
    end
  end
end
