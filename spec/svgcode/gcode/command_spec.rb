require 'spec_helper'

RSpec.describe Svgcode::GCode::Command do
  describe '.new' do
    context 'when a command string is passed' do
      let(:command) { Svgcode::GCode::Command.new('G0 X15 Y20.8') }

      it 'sets the letter' do
        expect(command.letter).to eq 'G'
      end

      it 'sets the number' do
        expect(command.number).to eq 0
      end

      it 'sets the args' do
        expect(command.args).to eq [
          Svgcode::GCode::Command.new(:x, 15),
          Svgcode::GCode::Command.new(:y, 20.8)
        ]
      end
    end

    context 'when a letter symbol, number and args array are passed' do
      let(:command) do
        Svgcode::GCode::Command.new(:g, 1, [
          Svgcode::GCode::Command.new(:x, 2.28)
        ])
      end

      it 'parses the letter to an uppercase string and sets it' do
        expect(command.letter).to eq 'G'
      end

      it 'sets the number' do
        expect(command.number).to eq 1
      end

      it 'sets the args' do
        expect(command.args).to eq [Svgcode::GCode::Command.new(:x, 2.28)]
      end
    end
  end

  describe '.parse_single' do
    context 'when a command string with no args is passed' do
      let(:command) { Svgcode::GCode::Command.parse_single('F1000.1') }

      it 'returns a new command object' do
        expect(command).to be_a Svgcode::GCode::Command
      end

      it "sets the returned command's letter" do
        expect(command.letter).to eq 'F'
      end

      it "sets the returned command's number" do
        expect(command.number).to eql 1000.1
      end

      it "sets the returned command's args to an empty array" do
        expect(command.args).to eq []
      end
    end
  end

  describe '#to_s' do
    context 'when the command letter is G' do
      let(:command) { Svgcode::GCode::Command.new(:g, 1) }

      it 'returns a string with a 2 character zero padded integer' do
        expect(command.to_s).to eq 'G01'
      end
    end

    context 'when the command letter is M' do
      let(:command) { Svgcode::GCode::Command.new(:m, 3.0) }

      it 'returns a string with a 2 character zero padded integer' do
        expect(command.to_s).to eq 'M03'
      end
    end

    context 'when the command letter is not G or M' do
      let(:command) { Svgcode::GCode::Command.new(:x, 80.67453) }

      it 'returns a string with a float rounded to 3 decimal places' do
        expect(command.to_s).to eq 'X80.675'
      end
    end

    context 'when the command has args' do
      let(:command) { Svgcode::GCode::Command.new('G0 X5.1235 Y7') }

      it 'returns a string with args separated by a space' do
        expect(command.to_s).to eq 'G00 X5.124 Y7.000'
      end
    end
  end

  describe '#==' do
    let(:a) { Svgcode::GCode::Command.new('G0 X155 Y50.5') }

    context 'when the letter, number and args are the same' do
      let(:b) { Svgcode::GCode::Command.new('G0 X155 Y50.5') }

      it 'returns true' do
        expect(a == b).to be true
      end
    end

    context 'when the letter differs' do
      let(:b) { Svgcode::GCode::Command.new('M0 X155 Y50.5') }

      it 'returns false' do
        expect(a == b).to be false
      end
    end

    context 'when the number differs' do
      let(:b) { Svgcode::GCode::Command.new('G1 X155 Y50.5') }

      it 'returns false' do
        expect(a == b).to be false
      end
    end

    context 'when the args differ' do
      let(:b) { Svgcode::GCode::Command.new('G0 X155') }

      it 'returns false' do
        expect(a == b).to be false
      end
    end
  end
end
