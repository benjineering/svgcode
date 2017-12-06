require 'spec_helper'

Command = Svgcode::GCode::Command

RSpec.describe :match_commands do
  context 'when the commands match' do
    let(:commands) do
      [
        Command.new('G91'),
        Command.new('F80.80'),
        Command.new('G0 X12'),
        Command.new('G01 X100.18 Y2')
      ]
    end

    it 'succeeds' do
      expect(commands).to match_commands 'g91, F, G0 X, G1 X Y2'
    end
  end

  context "when the commands don't match" do
    let(:commands) do
      [
        Command.new('G90'),
        Command.new('G0 X12 Y14')
      ]
    end

    it 'fails' do
      expect(commands).not_to match_commands 'G90, G00 X'
    end
  end
end
