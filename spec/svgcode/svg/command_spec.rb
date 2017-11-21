require 'spec_helper'

RSpec.describe Svgcode::SVG::Command do
  describe '.new' do
    context 'when a command string is passed with an uppercase letter' do
      let(:command) { Svgcode::SVG::Command.new('M50,88.2 8.0,15.15') }

      it 'sets the command name' do
        expect(command.name).to eq :move
      end

      it 'sets absolute to true' do
        expect(command.absolute).to be true
      end

      it 'sets the points' do
        expect(command.points).to eq [
          Svgcode::SVG::Point.new(50, 88.2),
          Svgcode::SVG::Point.new(8.0, 15.15)
        ]
      end
    end

    context 'when a command string is passed with an lowercase letter' do
      let(:command) { Svgcode::SVG::Command.new('l590,22.8') }

      it 'sets the command name' do
        expect(command.name).to eq :line
      end

      it 'sets absolute to false' do
        expect(command.absolute).to be false
      end

      it 'sets the points' do
        expect(command.points).to eq [
          Svgcode::SVG::Point.new(590, 22.8)
        ]
      end
    end

    context 'when a name symbol, absolute boolean and points array are passed' do
      let(:command) do
        Svgcode::SVG::Command.new(:cubic, true, [
          Svgcode::SVG::Point.new(8.8, 90.1),
          Svgcode::SVG::Point.new(15.5, 201.11)
        ])
      end

      it 'sets the command name' do
        expect(command.name).to eq :cubic
      end

      it 'sets the absolute value' do
        expect(command.absolute).to be true
      end

      it 'sets the points' do
        expect(command.points).to eq [
          Svgcode::SVG::Point.new(8.8, 90.1),
          Svgcode::SVG::Point.new(15.5, 201.11)
        ]
      end
    end
  end

  describe '#absolute?' do
    context 'the absolute attribute is true' do
      let(:command) { Svgcode::SVG::Command.new(:move, true) }

      it 'returns true' do
        expect(command.absolute?).to be true
      end
    end

    context 'the absolute attribute is false' do
      let(:command) { Svgcode::SVG::Command.new(:move, false) }

      it 'returns false' do
        expect(command.absolute?).to be false
      end
    end
  end

  describe '#relative?' do
    context 'the absolute attribute is true' do
      let(:command) { Svgcode::SVG::Command.new(:move, true) }

      it 'returns false' do
        expect(command.relative?).to be false
      end
    end

    context 'the absolute attribute is false' do
      let(:command) { Svgcode::SVG::Command.new(:move, false) }

      it 'returns true' do
        expect(command.relative?).to be true
      end
    end
  end
end
