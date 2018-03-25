require 'spec_helper'
require 'svgcode/svg/circle' # why do I need this?

module Svgcode
  module SVG
    RSpec.describe Circle do
      describe '.new' do
        context 'when x, y and r are passed' do
          let(:circle) { Circle.new(12, 13, 14) }

          it 'parses x to a float' do
            expect(circle.centre_x).to eql 12.0
          end

          it 'parses y to a float' do
            expect(circle.centre_y).to eql 13.0
          end

          it 'parses r to a float' do
            expect(circle.radius).to eql 14.0
          end
        end

        context 'when a circle element is passed' do
          let(:circle) do
            el = '<circle cx="100" cy="200" r="300"/>'
            Circle.new(Nokogiri::XML.fragment(el).children.first)
          end

          it 'parses x to a float' do
            expect(circle.centre_x).to eql 100.0
          end

          it 'parses y to a float' do
            expect(circle.centre_y).to eql 200.0
          end

          it 'parses r to a float' do
            expect(circle.radius).to eql 300.0
          end
        end
      end
    end
  end
end
