require 'svgcode/gcode/command'

module Svgcode
  module GCode
    class Program
      attr_accessor :opts, :commands
      attr_reader :is_plunged, :is_poised, :x, :y

      def initialize(opts = {})
        @is_plunged = false
        @is_poised = false
        @commands = opts.delete(:commands) || []

        @opts = {
          feedrate: 1_000,
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

      def <<(command)
        @commands << command
      end

      def metric!
        self << Command.metric
      end

      def absolute!
        self << Command.absolute
      end

      def relative!
        self << Command.relative
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
        clear! if @is_plunged
        self << Command.home
        @x = nil
        y = nil
        @is_poised = false
      end

      def go!(x, y)
        clear! if @is_plunged
        self << Command.go(x, y)
        @x = x
        @y = y
      end

      def cut!(x, y)
        plunge! unless @is_plunged
        self << Command.cut(x, y)
        @x = x
        @y = y
      end

      def clear!
        self << Command.clear(clearance)
        @is_plunged = false
        @is_poised = true
      end

      def plunge!
        clear! unless @is_poised
        self << Command.plunge(depth)
        @is_plunged = true
      end

      def cubic_spline!(i, j, _p, q, x, y)
        plunge! unless @is_plunged


        self << Command.cubic_spline(i, j,_p, q, x, y)


=begin
        self << Command.cubic_spline(
          i - @x,  j - @y, # relative to current pos
          _p - x, q - y,   # relative to next pos
          x,  y
        )
=end

        @x = x
        @y = y
      end

      def to_s
        @commands.join("\n")
      end
    end
  end
end
