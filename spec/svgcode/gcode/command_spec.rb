require 'spec_helper'

module Svgcode
  module GCode
    RSpec.describe Command do
      describe '.new' do
        context 'when a command string is passed' do
          let(:command) { Command.new('G0 X15 Y20.8') }

          it 'sets the letter' do
            expect(command.letter).to eq 'G'
          end

          it 'sets the number' do
            expect(command.number).to eq 0
          end

          it 'sets the args' do
            expect(command.args).to eq [
              Command.new(:x, 15),
              Command.new(:y, 20.8)
            ]
          end
        end

        context 'when a letter symbol, number and args array are passed' do
          let(:command) do
            Command.new(:g, 1, [
              Command.new(:x, 2.28)
            ])
          end

          it 'parses the letter to an uppercase string and sets it' do
            expect(command.letter).to eq 'G'
          end

          it 'sets the number' do
            expect(command.number).to eq 1
          end

          it 'sets the args' do
            expect(command.args).to eq [Command.new(:x, 2.28)]
          end
        end
      end

      describe '.parse_single' do
        context 'when a command string with no args is passed' do
          let(:command) { Command.parse_single('F1000.1') }

          it 'returns a new command object' do
            expect(command).to be_a Command
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
          let(:command) { Command.new(:g, 1) }

          it 'returns a string with a 2 character zero padded integer' do
            expect(command.to_s).to eq 'G01'
          end
        end

        context 'when the command letter is M' do
          let(:command) { Command.new(:m, 3.0) }

          it 'returns a string with a 2 character zero padded integer' do
            expect(command.to_s).to eq 'M03'
          end
        end

        context 'when the command letter is not G or M' do
          let(:command) { Command.new(:x, 80.67453) }

          it 'returns a string with a float rounded to 3 decimal places' do
            expect(command.to_s).to eq 'X80.675'
          end
        end

        context 'when the command has args' do
          let(:command) { Command.new('G0 X5.1235 Y7') }

          it 'returns a string with args separated by a space' do
            expect(command.to_s).to eq 'G00 X5.124 Y7.000'
          end
        end
      end

      describe '#==' do
        let(:a) { Command.new('G0 X155 Y50.5') }

        context 'when the letter, number and args are the same' do
          let(:b) { Command.new('G0 X155 Y50.5') }

          it 'returns true' do
            expect(a == b).to be true
          end
        end

        context 'when the letter differs' do
          let(:b) { Command.new('M0 X155 Y50.5') }

          it 'returns false' do
            expect(a == b).to be false
          end
        end

        context 'when the number differs' do
          let(:b) { Command.new('G1 X155 Y50.5') }

          it 'returns false' do
            expect(a == b).to be false
          end
        end

        context 'when the args differ' do
          let(:b) { Command.new('G0 X155') }

          it 'returns false' do
            expect(a == b).to be false
          end
        end
      end

      skip '#roughly_equal?'

      describe '.parse_single' do
        context 'when a string containing a single command is passed' do
          let(:command) { Command.parse_single('X15.78') }

          it 'returns a new command' do
            expect(command).to be_a Command
          end

          it "sets the returned command's letter" do
            expect(command.letter).to eq 'X'
          end

          it "sets the returned command's number" do
            expect(command.number).to eql 15.78
          end
        end
      end

      describe '.absolute' do
        let(:command) { Command.absolute }

        it 'returns a new command' do
          expect(command).to be_a Command
        end

        it "sets the returned command's letter to G" do
          expect(command.letter).to eq 'G'
        end

        it "sets the returned command's number to 90" do
          expect(command.number).to eq 90
        end
      end

      describe '.relative' do
        let(:command) { Command.relative }

        it 'returns a new command' do
          expect(command).to be_a Command
        end

        it "sets the returned command's letter to G" do
          expect(command.letter).to eq 'G'
        end

        it "sets the returned command's number to 91" do
          expect(command.number).to eq 91
        end
      end

      describe '.metric' do
        let(:command) { Command.metric }

        it 'returns a new command' do
          expect(command).to be_a Command
        end

        it "sets the returned command's letter to G" do
          expect(command.letter).to eq 'G'
        end

        it "sets the returned command's number to 21" do
          expect(command.number).to eq 21
        end
      end

      describe '.imperial' do
        let(:command) { Command.imperial }

        it 'returns a new command' do
          expect(command).to be_a Command
        end

        it "sets the returned command's letter to G" do
          expect(command.letter).to eq 'G'
        end

        it "sets the returned command's number to 20" do
          expect(command.number).to eq 20
        end
      end

      describe '.home' do
        let(:command) { Command.home }

        it 'returns a new command' do
          expect(command).to be_a Command
        end

        it "sets the returned command's letter to G" do
          expect(command.letter).to eq 'G'
        end

        it "sets the returned command's number to 30" do
          expect(command.number).to eq 30
        end
      end

      describe '.stop' do
        let(:command) { Command.stop }

        it 'returns a new command' do
          expect(command).to be_a Command
        end

        it "sets the returned command's letter to M" do
          expect(command.letter).to eq 'M'
        end

        it "sets the returned command's number to 2" do
          expect(command.number).to eq 2
        end
      end

      describe '.feedrate' do
        context 'when a feedrate float is passed'
        let(:command) { Command.feedrate(13.9998) }

        it 'returns a new command' do
          expect(command).to be_a Command
        end

        it "sets the returned command's letter to F" do
          expect(command.letter).to eq 'F'
        end

        it "sets the returned command's number to 13.9998" do
          expect(command.number).to eql 13.9998
        end
      end

      describe '.go' do
        context 'when x and y floats are passed' do
          let(:command) { Command.go(20.2, 15.632) }

          it 'returns a new command' do
            expect(command).to be_a Command
          end

          it "sets the returned command's letter to G" do
            expect(command.letter).to eq 'G'
          end

          it "sets the returned command's number to 0" do
            expect(command.number).to eq 0
          end

          it "sets the returned command's args to X20.2 and Y15.632" do
            expect(command.args).to eq [
              Command.new(:x, 20.2),
              Command.new(:y, 15.632)
            ]
          end
        end
      end

      describe '.cut' do
        context 'when x and y floats are passed' do
          let(:command) { Command.cut(8, 19.19) }

          it 'returns a new command' do
            expect(command).to be_a Command
          end

          it "sets the returned command's letter to G" do
            expect(command.letter).to eq 'G'
          end

          it "sets the returned command's number to 1" do
            expect(command.number).to eq 1
          end

          it "sets the returned command's args to X8.0 and Y19.19" do
            expect(command.args).to eq [
              Command.new(:x, 8.0),
              Command.new(:y, 19.19)
            ]
          end
        end
      end

      describe '.cubic_spline' do
        context 'when i, j, p, q, x and y floats are passed' do
          let(:command) do
            Command.cubic_spline(1.1, 2.2, 3.3, 4.4, 5.5, 6.6)
          end

          it 'returns a new command' do
            expect(command).to be_a Command
          end

          it "sets the returned command's letter to G" do
            expect(command.letter).to eq 'G'
          end

          it "sets the returned command's number to 5" do
            expect(command.number).to eq 5
          end

          it "sets the returned command's args to \
          I1.1, J2.2, P3.3, Q4.4 X5.5 Y6.6" do
            expect(command.args).to eq [
              Command.new(:i, 1.1),
              Command.new(:j, 2.2),
              Command.new(:p, 3.3),
              Command.new(:q, 4.4),
              Command.new(:x, 5.5),
              Command.new(:y, 6.6)
            ]
          end
        end
      end

      describe '.clear' do
        context 'when a clearance float of 5.565 is passed' do
          let(:command) do
            Command.clear(5.565)
          end

          it 'returns a new command' do
            expect(command).to be_a Command
          end

          it "sets the returned command's letter to G" do
            expect(command.letter).to eq 'G'
          end

          it "sets the returned command's number to 0" do
            expect(command.number).to eq 0
          end

          it "sets the returned command's args to Z5.565" do
            expect(command.args).to eq [
              Command.new(:z, 5.565)
            ]
          end
        end
      end

      describe '.plunge' do
        context 'when a plunge float of 2 is passed' do
          let(:command) do
            Command.plunge(2)
          end

          it 'returns a new command' do
            expect(command).to be_a Command
          end

          it "sets the returned command's letter to G" do
            expect(command.letter).to eq 'G'
          end

          it "sets the returned command's number to 1" do
            expect(command.number).to eq 1
          end

          it "sets the returned command's args to Z2.0" do
            expect(command.args).to eq [
              Command.new(:z, 2.0)
            ]
          end
        end
      end

      skip '.g'

      skip '.m'
    end
  end
end
