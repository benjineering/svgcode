require 'spec_helper'

module Svgcode
  module GCode
    RSpec.describe Program do
      describe '.new' do
        context 'when the feedrate, clearance, depth, an absolute boolean '\
        'and a command are passed' do
          let(:program) do
            Program.new(
              feedrate: 2.3,
              clearance: 28.5,
              depth: 18,
              absolute: false,
              commands: [
                Command.new('G01 X18.99 Y52.222')
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

          it 'sets @is_absolute' do
            expect(program.is_absolute).to be false
          end

          it 'sets @commands' do
            expect(program.commands).to match_commands 'G1 X18.99 Y52.222'
          end
        end

        context 'when no parameter is passed' do
          let(:program) { Program.new }

          it 'sets the feedrate option to Program::DEFAULT_FEEDRATE' do
            expect(program.opts[:feedrate]).to eq Program::DEFAULT_FEEDRATE
          end

          it 'sets the clearance option to 5' do
            expect(program.opts[:clearance]).to eq 5
          end

          it 'sets the depth option to -0.075' do
            expect(program.opts[:depth]).to eq -0.075
          end

          it 'sets @is_absolute to true' do
            expect(program.is_absolute).to be true
          end

          it 'sets @commands to an empty array' do
            expect(program.commands).to eq []
          end
        end
      end

      describe '#feedrate' do
        context 'when the feedrate is set' do
          let(:program) { Program.new(feedrate: 3003.01) }

          it 'returns the feedrate' do
            expect(program.feedrate).to eql 3003.01
          end
        end
      end

      describe '#clearance' do
        context 'when the clearance is set' do
          let(:program) { Program.new(clearance: 8.5) }

          it 'returns the clearance' do
            expect(program.clearance).to eql 8.5
          end
        end
      end

      describe '#depth' do
        context 'when the depth is set' do
          let(:program) { Program.new(depth: 0.25) }

          it 'returns the depth' do
            expect(program.depth).to eql 0.25
          end
        end
      end

      describe '#plunged?' do
        context 'when no commands have been called' do
          let(:program) { Program.new }

          it 'returns false' do
            expect(program.plunged?).to be false
          end
        end

        context 'when #plunge! has been called' do
          let(:program) do
            prog = Program.new
            prog.plunge!
            prog
          end

          it 'returns true' do
            expect(program.plunged?).to be true
          end
        end

        context 'when #plunge! then #clear! have been called' do
          let(:program) do
            prog = Program.new
            prog.plunge!
            prog.clear!
            prog
          end

          it 'returns false' do
            expect(program.plunged?).to be false
          end
        end
      end

      describe '#poised?' do
        context 'when no commands have been called' do
          let(:program) { Program.new }

          it 'returns false' do
            expect(program.poised?).to be false
          end
        end

        context 'when #clear! has been called' do
          let(:program) do
            prog = Program.new
            prog.clear!
            prog
          end

          it 'returns true' do
            expect(program.poised?).to be true
          end
        end

        context 'when #clear! then #home! have been called' do
          let(:program) do
            prog = Program.new
            prog.clear!
            prog.home!
            prog
          end

          it 'returns false' do
            expect(program.poised?).to be false
          end
        end
      end

      describe '#pos' do
        context 'when #go! has been called' do
          let(:program) do
            prog = Program.new
            prog.go!(12, 1982.01)
            prog
          end

          it 'returns the current position as a point' do
            expect(program.pos).to eq Svgcode::SVG::Point.new(12, 1982.01)
          end
        end
      end

      describe '#<<' do
        context 'when relative and a G0 command is passed to an empty program' do
          let(:program) do
            prog = Program.new(absolute: false)
          end

          it 'raises an invalid command error' do
            expect { program << Command.new('G0 Y15') }.to(
              raise_error InvalidCommandError
            )
          end
        end

        context 'when absolute and a G01 command is passed to an empty program' do
          let(:program) do
            prog = Program.new(absolute: true)
            prog << Command.new('G1 X12.3')
            prog
          end

          it 'adds G90 and the command to @commands' do
            expect(program.commands).to match_commands 'G90, G1 X'
          end
        end

        context 'when absolute and a G91 command is passed to an empty program' do
          let(:program) do
            prog = Program.new(absolute: true)
            prog << Command.new('G91')
            prog
          end

          it 'adds only the G91 command to @commands' do
            expect(program.commands).to match_commands 'G91'
          end
        end

        context 'when an M02 command is passed to an empty program' do
          let(:program) do
            prog = Program.new
            prog << Command.new('M02')
            prog
          end

          it 'adds only the M02 command to @commands' do
            expect(program.commands).to match_commands 'M2'
          end
        end
      end

      skip '#comment!'

      describe '#metric!' do
        context 'when nothing has been called' do
          let(:program) do
            prog = Program.new
            prog.metric!
            prog
          end

          it 'adds a G21 command to @commands' do
            expect(program.commands.last).to eq Command.new('G21')
          end
        end
      end

      describe '#imperial!' do
        context 'when nothing has been called' do
          let(:program) do
            prog = Program.new
            prog.imperial!
            prog
          end

          it 'adds a G20 command to @commands' do
            expect(program.commands.last).to eq Command.new('G20')
          end
        end
      end

      describe '#absolute!' do
        context 'when @is_absolute is false' do
          let(:program) do
            prog = Program.new(absolute: false)
            prog.absolute!
            prog
          end

          it 'adds a G90 command to @commands' do
            expect(program.commands).to match_commands 'G90'
          end
        end

        context 'when @is_absolute is true' do
          let(:program) do
            prog = Program.new(absolute: true)
            prog.absolute!
            prog
          end

          it 'adds no command to @commands' do
            expect(program.commands).to eq []
          end
        end
      end

      describe '#relative!' do
        context 'when @is_absolute is true' do
          let(:program) do
            prog = Program.new(absolute: true)
            prog.relative!
            prog
          end

          it 'adds a G91 command to @commands' do
            expect(program.commands).to match_commands 'G91'
          end
        end

        context 'when @is_absolute is false' do
          let(:program) do
            prog = Program.new(absolute: false)
            prog.relative!
            prog
          end

          it 'adds no command to @commands' do
            expect(program.commands).to eq []
          end
        end
      end

      describe '#feedrate!' do
        context 'when #absolute! has been called and '\
        'a feedrate float is passed' do
          let(:program) do
            prog = Program.new
            prog.absolute!
            prog.feedrate!(1_800)
            prog
          end

          it 'adds an F command to @commands' do
            expect(program.commands.last).to eq Command.new('F1800')
          end
        end

        context 'when #relative! has been called and the feedrate is set '\
        'but no parameter is passed' do
          let(:program) do
            prog = Program.new(feedrate: 2_000)
            prog.relative!
            prog.feedrate!
            prog
          end

          it 'adds an F command to @commands' do
            expect(program.commands.last).to eq Command.new('F2000')
          end
        end
      end

      describe '#stop!' do
        let(:program) do
          prog = Program.new
          prog.stop!
          prog
        end

        it 'adds an M02 command to @commands' do
          expect(program.commands).to match_commands 'M2'
        end
      end

      describe '#home!' do
        context 'when the spindle is plunged' do
          let(:program) do
            prog = Program.new
            prog.go!(12, 13)
            prog.plunge!
            prog.home!
            prog
          end

          it 'adds a G0 Z and a G30 command to @commands' do
            expect(program.commands.last(2)).to match_commands 'G0 Z, G30'
          end

          it 'sets is_plunged to false' do
            expect(program.is_plunged).to be false
          end

          it 'sets is_poised to false' do
            expect(program.is_poised).to be false
          end

          it 'sets x to nil' do
            expect(program.x).to be nil
          end

          it 'sets y to nil' do
            expect(program.y).to be nil
          end
        end

        context 'when the spindle is poised' do
          let(:program) do
            prog = Program.new
            prog.go!(20, 18.88)
            prog.clear!
            prog.home!
            prog
          end

          it 'adds a G30 command to @commands' do
            expect(program.commands.last).to eq Command.new('G30')
          end

          it 'sets is_plunged to false' do
            expect(program.is_plunged).to be false
          end

          it 'sets is_poised to false' do
            expect(program.is_poised).to be false
          end

          it 'sets x to nil' do
            expect(program.x).to be nil
          end

          it 'sets y to nil' do
            expect(program.y).to be nil
          end
        end

        context 'when the spindle is neither plunged nor poised' do
          let(:program) do
            prog = Program.new
            prog.home!
            prog
          end

          it 'adds no commands to @commands' do
            expect(program.commands).to eq []
          end

          it 'sets is_plunged to false' do
            expect(program.is_plunged).to be false
          end

          it 'sets is_poised to false' do
            expect(program.is_poised).to be false
          end

          it 'sets x to nil' do
            expect(program.x).to be nil
          end

          it 'sets y to nil' do
            expect(program.y).to be nil
          end
        end
      end

      describe '#clear!' do
        context 'when absolute and not plunged' do
          let(:program) do
            prog = Program.new(absolute: true)
            prog.clear!
            prog
          end

          it 'adds a G0 Z command according to @clearance' do
            expect(program.commands.last).to eq(
              Command.new("G00 Z#{program.clearance}")
            )
          end

          it 'sets poised to true' do
            expect(program.poised?).to be true
          end
        end

        context 'when relative and plunged' do
          let(:program) do
            prog = Program.new(absolute: false)
            prog.plunge!
            prog.clear!
            prog
          end

          it 'adds a G0 Z command according to @clearance' do
            second_last_command = program.commands[program.commands.length - 2]

            expect(second_last_command).to eq(
              Command.new("G00 Z#{program.clearance}")
            )
          end

          it 'sets poised to true' do
            expect(program.poised?).to be true
          end

          it 'sets plunged to false' do
            expect(program.plunged?).to be false
          end
        end
      end

      describe '#plunge!' do
        context 'when absolute and not poised' do
          let(:program) do
            prog = Program.new(absolute: true)
            prog.plunge!
            prog
          end

          it 'adds a G1 Z command according to @depth' do
            expect(program.commands.last).to eq(
              Command.new("G1 Z#{program.depth}")
            )
          end

          it 'sets poised to true' do
            expect(program.poised?).to be true
          end

          it 'sets plunged to true' do
            expect(program.plunged?).to be true
          end
        end

        context 'when relative and poised' do
          let(:program) do
            prog = Program.new
            prog.clear!
            prog.relative!
            prog.plunge!
            prog
          end

          it 'adds a G1 Z command according to @depth' do
            second_last_command = program.commands[program.commands.length - 2]

            expect(second_last_command).to eq(
              Command.new("G1 Z#{program.depth}")
            )
          end

          it 'sets poised to true' do
            expect(program.poised?).to be true
          end

          it 'sets plunged to true' do
            expect(program.plunged?).to be true
          end
        end
      end

      describe '#go!' do
        context 'when absolute, the spindle is plunged and '\
        'x and y values are passed' do
          let(:program) do
            prog = Program.new(absolute: true)
            prog.go!(1, 11.9)
            prog.plunge!
            prog.go!(22.32, 42)
            prog
          end

          it 'adds a clearance GZ and a G0 XY command to @commands' do
            expect(program.commands.last(2)).to match_commands 'G0 Z, G0 X Y'
          end

          it 'sets is_plunged to false' do
            expect(program.is_plunged).to be false
          end

          it 'sets is_poised to true' do
            expect(program.is_poised).to be true
          end

          it 'sets the x attribute' do
            expect(program.x).to eq 22.32
          end

          it 'sets the y attribute' do
            expect(program.y).to eq 42
          end
        end

        context 'when relative, the spindle is not plunged and '\
        'x and y values are passed' do
          let(:program) do
            prog = Program.new
            prog.go!(100, 100)
            prog.relative!
            prog.go!(83.9, 91)
            prog
          end

          it 'adds a G0 XY command to @commands' do
            expect(program.commands.last).to eq(
              Command.new('G0 X83.9 Y91')
            )
          end

          it 'sets is_plunged to false' do
            expect(program.is_plunged).to be false
          end

          it 'sets is_poised to false' do
            expect(program.is_poised).to be false
          end

          it 'increments the x attribute' do
            expect(program.x).to eq 100 + 83.9
          end

          it 'increments the y attribute' do
            expect(program.y).to eq 100 + 91
          end
        end
      end

      describe '#cut!' do
        context 'when absolute, the spindle is plunged and '\
        'x and y values are passed' do
          let(:program) do
            prog = Program.new(absolute: true)
            prog.plunge!
            prog.cut!(888.88, 1920)
            prog
          end

          it 'adds a G1 XY command to @commands' do
            expect(program.commands.last).to eq(
              Command.new('G1 X888.88 Y1920.0')
            )
          end

          it 'sets the x attribute' do
            expect(program.x).to eq 888.88
          end

          it 'sets the y attribute' do
            expect(program.y).to eq 1920
          end
        end

        context "when relative, the spindle isn't plunged and "\
        "x and y values are passed" do
          let(:program) do
            prog = Program.new
            prog.go!(20, 222.3)
            prog.relative!
            prog.cut!(5, 0.689)
            prog
          end

          it 'adds a G1 XY command to @commands' do
            expect(program.commands.last).to eq(
              Command.new('G1 X5.0 Y0.689')
            )
          end

          it 'sets is_plunged to true' do
            expect(program.is_plunged).to be true
          end

          it 'increments the x attribute' do
            expect(program.x).to eq 20 + 5
          end

          it 'increments the y attribute' do
            expect(program.y).to eq 222.3 + 0.689
          end
        end
      end

      describe '#cubic_spline!' do
        context "when absolute, the spindle isn't plunged and 6 values are passed" do
          let(:program) do
            prog = Program.new
            prog.go!(1, 22)
            prog.cubic_spline!(5, 0.689, 18.9, 6, 1888, 97.001)
            prog
          end

          it 'adds a plunge command to @commands' do
            second_last_command = program.commands[program.commands.length - 2]

            expect(second_last_command).to eq(
              Command.new("G1 Z#{program.depth}")
            )
          end

          it 'adds a G5 command' do
            expect(program.commands.last(1)).to match_commands 'G5 I J P Q X Y'
          end

          it 'sets is_plunged to true' do
            expect(program.is_plunged).to be true
          end

          it 'sets the x attribute' do
            expect(program.x).to eq 1888
          end

          it 'sets the y attribute' do
            expect(program.y).to eq 97.001
          end
        end

        context 'when relative, the spindle is plunged and 6 values are passed' do
          let(:start_x) { 15 }
          let(:start_y) { 0 }
          let(:x) { 198 }
          let(:y) { 198.8 }

          let(:program) do
            prog = Program.new
            prog.go!(start_x, start_y)
            prog.relative!
            prog.cubic_spline!(16, -0.00245, -1, 1.65, x, y)
            prog
          end

          it 'adds a G5 command' do
            expect(program.commands.last(1)).to match_commands 'G5 I J P Q X Y'
          end

          it 'increments the x attribute' do
            expect(program.x).to eq start_x + x
          end

          it 'increments the y attribute' do
            expect(program.y).to eq start_y + y
          end
        end
      end

      describe '#arc!' do
        skip 'adds a G0 and G2 command'
      end

      describe '#to_s' do
        context 'when #go! and #cut! have been called' do
          let(:start_x) { 0.001 }
          let(:start_y) { 1.11 }
          let(:x) { 182 }
          let(:y) { 20 }

          let(:program) do
            prog = Program.new
            prog.go!(start_x, start_y)
            prog.cut!(x, y)
            prog
          end

          it 'returns a g-code string with G90, G0 XY, G0 clear, G1 plunge and '\
          'G1 XY commands' do
            float = '-?\d+\.\d+'

            expect(program.to_s).to match(
              "G90\n"\
              "G00 X#{float} Y#{float}\n"\
              "G00 Z#{float}\n"\
              "G01 Z#{float}\n"\
              "G01 X#{float} Y#{float}"
            )
          end
        end
      end
    end
  end
end
