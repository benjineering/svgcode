require 'svgcode/gcode/command'
require 'svgcode/gcode/invalid_command_error'

module Svgcode
  module GCode
    class Program
      attr_accessor :opts, :commands

      # 3 states
      # ========
      # at Z home height:          @is_poised = false, @is_plunged = false
      # at Z clearance height:     @is_poised = true,  @is_plunged = false
      # at Z cutting depth height: @is_poised = true,  @is_plunged = true
      attr_reader :is_plunged, :is_poised, :is_absolute, :x, :y

      def initialize(opts = {})
        @is_plunged = false
        @is_poised = false
        @commands = opts.delete(:commands) || []
        @is_absolute = opts.delete(:absolute)
        @is_absolute = true if @is_absolute.nil?

        @opts = {
          feedrate: 120,
          clearance: 5,
          depth: -0.5
        }.merge(opts)
      end

      def feedrate
        @opts[:feedrate]
      end

      def clearance
        @opts[:clearance]
      end

      def depth
        @opts[:depth]
      end

      def plunged?
        @is_plunged
      end

      def poised?
        @is_poised
      end

      def absolute?
        @is_absolute
      end

      def relative?
        @is_absolute.nil? ? nil : !@is_absolute
      end

      def <<(command)
        if (@x.nil? || @y.nil?) && 
          command.letter == 'G' &&
          command.number < 6 &&
          command != Command.relative &&
          command != Command.absolute
        then
          if relative?
            raise InvalidCommandError.new(
              'Cannot add a command when relative and @x or @y are nil'
            )
          else
            @commands << Command.absolute
          end
        end

        @commands << command
      end

      def metric!
        self << Command.metric
      end

      def imperial!
        self << Command.imperial
      end

      def absolute!
        unless absolute?
          self << Command.absolute
          @is_absolute = true
        end
      end

      def relative!
        unless relative?
          self << Command.relative
          @is_absolute = false
        end
      end

      def feedrate!(rate = nil)
        if rate.nil?
          rate = feedrate
        else
          @opts[:feedrate] = rate
        end

        self << Command.feedrate(rate)
      end

      def stop!
        self << Command.stop
      end

      def home!
        clear! if plunged?
        @commands.pop if @commands.last == Command.relative
        self << Command.home if poised?
        @x = nil
        @y = nil
        @is_poised = false
      end

      def clear!
        temp_absolute { self << Command.clear(clearance) }
        @is_plunged = false
        @is_poised = true
      end

      def plunge!
        clear! unless poised?
        temp_absolute { self << Command.plunge(depth) }
        @is_plunged = true
      end

      def go!(x, y)
        clear! if plunged?
        self << Command.go(x, y)
        set_coords(x, y)
      end

      def cut!(x, y)
        perform_cut(x, y) { self << Command.cut(x, y) }
      end

      def cubic_spline!(i, j, _p, q, x, y)
        perform_cut(x, y) do
          self << Command.cubic_spline(i, j, _p, q, x, y)
        end
      end

      def pos
        Svgcode::SVG::Point.new(@x, @y)
      end

      def to_s
        @commands.join("\n")
      end

      private

      def perform_cut(x, y)
        plunge! unless plunged?
        yield
        set_coords(x, y)
      end

      def temp_absolute
        was_relative = relative?

        if @commands.last == Command.relative
          @commands.pop
          @is_absolute = true
        end

        absolute! if relative?
        yield
        relative! if was_relative
      end

      def set_coords(x, y)
        if absolute?
          @x = x
          @y = y
        else
          @x += x
          @y += y
        end
      end
    end
  end
end
