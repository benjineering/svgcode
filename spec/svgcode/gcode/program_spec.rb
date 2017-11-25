require 'spec_helper'

RSpec.describe Svgcode::GCode::Program do
  describe '.new' do
    context 'when a feedrate of 2.3, a clearance of 28.5, a depth of 18 and a \
    command of G01 X18.99 Y52.222 is passed' do
      let(:program) do
        Svgcode::GCode::Program.new(
          feedrate: 2.3,
          clearance: 28.5,
          depth: 18,
          commands: [
            Svgcode::GCode::Command.new('G01 X18.99 Y52.222')
          ]
        )
      end

      it 'sets the feedrate option' do
        expect(program.opts[:feedrate]).to eq 2.3
      end

      it 'sets the clearance option' do
        expect(program.opts[:clearance]).to eq 28.5
      end

      it 'sets the depth option' do
        expect(program.opts[:depth]).to eq 18
      end

      it 'sets the commands' do
        expect(program.commands).to eq [
          Svgcode::GCode::Command.new('G01 X18.99 Y52.222')
        ]
      end
    end
  end

  skip '#feedrate' do

  end

  skip '#clearance' do

  end

  skip '#depth' do

  end

  skip '#<<' do

  end

  skip '#metric!' do

  end

  skip '#absolute!' do

  end

  skip '#feedrate!' do

  end

  skip '#stop!' do

  end

  skip '#home!' do

  end

  skip '#go!' do

  end

  skip '#cut!' do

  end

  skip '#clear!' do

  end

  skip '#plunge!' do

  end

  skip '#cubic_spline!' do

  end

  skip '#to_s' do

  end
end
