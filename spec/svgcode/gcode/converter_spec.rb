require 'spec_helper'

module Svgcode
  module GCode
    RSpec.describe Converter do
      describe '.new' do
        context 'when an option hash is passed' do
          let(:converter) do
            Converter.new(
              max_y: 18.8,
              metric: false,
              feedrate: 1_110.2,
              clearance: 2,
              depth: -1
            )
          end

          it 'sets finished to false' do
            expect(converter.finished).to be false
          end

          it 'creates a new program' do
            expect(converter.program).to be_a Program
          end

          it 'sets @max_y from opts' do
            expect(converter.max_y).to eq 18.8
          end

          it "sets the new program's feedrate from opts" do
            expect(converter.program.feedrate).to eq 1_110.2
          end

          it "sets the new program's clearance from opts" do
            expect(converter.program.clearance).to eq 2
          end

          it "sets the new program's depth from opts" do
            expect(converter.program.depth).to eq -1
          end

          it 'adds an imperial and a feedrate command to the program' do
            expect(converter.program.commands).to match_commands 'G20, F'
          end
        end

        context 'when only max_y is passed in opts' do
          let(:converter) { Converter.new(max_y: 300) }

          it 'sets finished to false' do
            expect(converter.finished).to be false
          end

          it 'creates a new program' do
            expect(converter.program).to be_a Program
          end

          it 'sets @max_y from opts' do
            expect(converter.max_y).to eq 300
          end

          it 'adds metric and feedrate commands to the program' do
            expect(converter.program.commands).to match_commands 'G21, F'
          end
        end

        context 'when nothing is passed' do
          let(:converter) { Converter.new }

          it 'raises an ArgumentError' do
            expect { converter }.to raise_error ArgumentError
          end
        end

        context 'when opts is passed without a max_y value' do
          let(:converter) { Converter.new }

          it 'raises an ArgumentError' do
            expect { converter }.to raise_error ArgumentError
          end
        end
      end

      describe '#<<' do
        context 'when an SVG path description string containing an absolute move "\
        "and a relative line command is passed' do
          let(:converter) do
            c = Converter.new(max_y: 100)
            c << 'M2848.82,0l0,86.22'
            c
          end

          it 'adds metric, feedrate, absolute, go, clear, plunge, relative and '\
          'cut commands to the program, negating any y values' do
            expect(converter.program.commands).to match_commands(
              'G21, F, G90, G0 X Y, G0 Z, G1 Z, G91, G1 X Y'
            )
          end

          context 'when an SVG circle is passed' do
            let(:converter) do
              c = Converter.new(max_y: 100)
              c << Svgcode::SVG::Circle.new(89.6, 15, 22.2222)
              c
            end

            it 'adds go, XY plane selection and arc move commands' do
              expect(converter.program.commands).to match_commands(
                'G21, F, G90, G0 X Y, G0 Z, G1 Z, G91, G17, G2 X Y R'
              )
            end
          end
        end

        skip 'when the start of a cut is an absolute command and close is called'

        skip 'when the start of a cut is a relative command and close is called'

        skip 'when the command contains a relative cubic spline'

        skip 'when the command contains an absolute cubic spline'

        skip 'when @transforms contains transform objects'
      end

      skip '#metric?'

      skip '#comment!'

      describe '#finish' do
        context 'when a move and a cut path has been converted' do
          let(:converter) do
            c = Converter.new(max_y: 100)
            c << 'M12.2,180 L12,80'
            c.finish
            c
          end

          it 'adds clear, home and stop commands to the program' do
            expect(converter.program.commands.last(3)).to match_commands(
              'G0 Z5, G0 X0 Y0, M02'
            )
          end

          it 'sets @finished to true' do
            expect(converter.finished).to be true
          end
        end
      end

      describe '#to_s' do
        context 'when a move and a cut path has been converted and '\
        'finish has been called' do
          let(:converter) do
            c = Converter.new(max_y: 100)
            c << 'M1.11,122 l0,-202'
            c.finish
            c
          end

          it 'returns a formatted g-code string' do
            float = '-?\\d+\\.\\d+'
            expect(converter.to_s).to match(
              "G21\n"\
              "F#{float}\n"\
              "G90\n"\
              "G00 X#{float} Y#{float}\n"\
              "G00 Z#{float}\n"\
              "G01 Z#{float}\n"\
              "G91\n"\
              "G01 X#{float} Y#{float}\n"\
              "G90\n"\
              "G00 Z#{float}\n"\
              "G91\n"\
              "G00 X#{float} Y#{float}\n"\
              "M02"
            )
          end
        end
      end
    end
  end
end
