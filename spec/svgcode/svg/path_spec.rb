require 'spec_helper'

RSpec.describe Svgcode::SVG::Path do
  describe '.new' do
    context 'when a path description string is passed' do
      let(:path) { Svgcode::SVG::Path.new('M37,17l2,9.1z M50,0l18,17.0z') }

      skip 'parses commands to objects and saves them' do
        expect(path).to eq [
          Svgcode::SVG::Command.new(:move, true, 37, 17),
          Svgcode::SVG::Command.new(:line, false, 2, 9.1),
          Svgcode::SVG::Command.new(:close),
          Svgcode::SVG::Command.new(:move, true, 50, 0),
          Svgcode::SVG::Command.new(:line, false, 18, 17.0),
          Svgcode::SVG::Command.new(:close)
        ]
      end
    end
  end
end
