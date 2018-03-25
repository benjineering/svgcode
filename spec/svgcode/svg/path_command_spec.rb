require 'spec_helper'

module Svgcode
  module SVG
    RSpec.describe PathCommand do
      describe '.new' do
        context 'when a command string is passed with an uppercase letter' do
          let(:command) { PathCommand.new('M50,88.2 8.0,15.15') }

          it 'sets the command name' do
            expect(command.name).to eq :move
          end

          it 'sets absolute to true' do
            expect(command.absolute?).to be true
          end

          it 'sets the points' do
            expect(command.points).to eq [
              Point.new(50, 88.2),
              Point.new(8.0, 15.15)
            ]
          end
        end

        context 'when a command string is passed with an lowercase letter' do
          let(:command) { PathCommand.new('l590,22.8') }

          it 'sets the command name' do
            expect(command.name).to eq :line
          end

          it 'sets absolute to false' do
            expect(command.absolute?).to be false
          end

          it 'sets the points' do
            expect(command.points).to eq [
              Point.new(590, 22.8)
            ]
          end
        end

        context 'when an options hash is passed' do
          let(:command) do
            PathCommand.new(name: :cubic, absolute: true, points: [
              Point.new(8.8, 90.1),
              Point.new(15.5, 201.11)
            ])
          end

          it 'sets the command name' do
            expect(command.name).to eq :cubic
          end

          it 'sets the absolute value' do
            expect(command.absolute?).to be true
          end

          it 'sets the points' do
            expect(command.points).to eq [
              Point.new(8.8, 90.1),
              Point.new(15.5, 201.11)
            ]
          end
        end
      end

      describe '#absolute?' do
        context 'when the absolute attribute is true' do
          let(:command) { PathCommand.new(name: :move, absolute: true) }

          it 'returns true' do
            expect(command.absolute?).to be true
          end
        end

        context 'when the absolute attribute is false' do
          let(:command) { PathCommand.new(name: :move, absolute: false) }

          it 'returns false' do
            expect(command.absolute?).to be false
          end
        end
      end

      describe '#relative?' do
        context 'when the absolute attribute is true' do
          let(:command) { PathCommand.new(name: :move, absolute: true) }

          it 'returns false' do
            expect(command.relative?).to be false
          end
        end

        context 'when the absolute attribute is false' do
          let(:command) { PathCommand.new(name: :move, absolute: false) }

          it 'returns true' do
            expect(command.relative?).to be true
          end
        end
      end

      describe '#==' do
        let(:a) do
          PathCommand.new(name: :cubic, absolute: true, points: [
            Point.new(166, 15.815),
            Point.new(3, 12.99)
          ])
        end

        context 'when name, absolute and points are the same' do
          let(:b) do
            PathCommand.new(name: :cubic, absolute: true, points: [
              Point.new(166, 15.815),
              Point.new(3, 12.99)
            ])
          end

          it 'returns true' do
            expect(a == b).to be true
          end
        end

        context 'when name differs' do
          let(:b) do
            PathCommand.new(name: :line, absolute: true, points: [
              Point.new(166, 15.815),
              Point.new(3, 12.99)
            ])
          end

          it 'returns false' do
            expect(a == b).to be false
          end
        end

        context 'when absolute differs' do
          let(:b) do
            PathCommand.new(name: :cubic, absolute: false, points: [
              Point.new(166, 15.815),
              Point.new(3, 12.99)
            ])
          end

          it 'returns false' do
            expect(a == b).to be false
          end
        end

        context 'when points differ' do
          let(:b) do
            PathCommand.new(name: :cubic, absolute: true, points: [
              Point.new(3, 12.99)
            ])
          end

          it 'returns false' do
            expect(a == b).to be false
          end
        end
      end

      skip '#apply_transforms!'

      describe '#negate_points_y' do
        context 'when the command has multiple points' do
          let(:command) do
            PathCommand.new('c4.025,0 7.476,1.448 10.353,4.344')
          end

          it "returns a new command with each point's y negated" do
            expect(command.negate_points_y).to eq(
              PathCommand.new('c4.025,-0 7.476,-1.448 10.353,-4.344')
            )
          end
        end
      end

      describe '#negate_points_y!' do
        context 'when the command has multiple points' do
          let(:command) do
            cmd = PathCommand.new('c4.025,0 7.476,1.448 10.353,4.344')
            cmd.negate_points_y!
            cmd
          end

          it 'negates the y of each point in place' do
            expect(command).to eq(
              PathCommand.new('c4.025,-0 7.476,-1.448 10.353,-4.344')
            )
          end
        end
      end

      skip '#name_str'

      skip '#divide_points_by!'

      skip '#flip_points_y!'

      skip '#absolute'

      skip '#absolute!'

      describe '.name_str' do
        context 'when a legitimate symbol and a boolean value are passed' do
          let(:string) { PathCommand.name_str(:line, true) }

          it 'returns a string containing the correct letter, '\
          'capitalised if absolute' do
            expect(string).to eq 'L'
          end
        end
      end
    end
  end
end
