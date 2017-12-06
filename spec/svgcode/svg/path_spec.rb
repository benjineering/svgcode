require 'spec_helper'

module Svgcode
  module SVG
    RSpec.describe Path do
      describe '.new' do
        context 'when a path description string is passed' do
          let(:path) { Path.new('M37,17l2,9.1z M50,0l18,17.0z') }

          it 'parses commands to objects and saves them' do
            expect(path.commands).to eq [
              Command.new(
                name: :move,
                absolute: true,
                points: [Point.new(37, 17)]
              ),
              Command.new(
                name: :line,
                absolute: false,
                points: [Point.new(2, 9.1)]
              ),
              Command.new(name: :close, absolute: true),
              Command.new(
                name: :move,
                absolute: true,
                points: [Point.new(50, 0)]
              ),
              Command.new(
                name: :line,
                absolute: false,
                points: [Point.new(18, 17.0)]
              ),
              Command.new(name: :close, absolute: true)
            ]
          end
        end
      end
    end
  end
end
