require 'svgcode/gcode/program'
require 'svgcode/svg/path'

module Svgcode
  module GCode
    class Converter
      PX_PER_INCH = 300
      PX_PER_MM = PX_PER_INCH / 25.4

      attr_reader :program, :finished, :metric, :max_y

      def initialize(opts)
        @finished = false
        @max_y = opts.delete(:max_y)
        @program = Program.new(opts)
        @metric = opts[:metric] != false
        @metric ? @program.metric! : @program.imperial!
        @program.feedrate!
      end

      def <<(svg_d)
        svg_start = nil
        path = SVG::Path.new(svg_d)
        start = nil

        path.commands.each do |cmd|
          cmd.absolute? ? cmd.flip_points_y!(@max_y) : cmd.negate_points_y!

          if metric?
            cmd.divide_points_by!(PX_PER_MM)
          else
            cmd.divide_points_by!(PX_PER_INCH)
          end

          if (cmd.name == :close || cmd.absolute?) && @program.relative?
            @program.absolute!
          elsif cmd.relative? && @program.absolute?
            @program.relative!
          end

          case cmd.name
          when :move
            @program.go!(cmd.points.first.x, cmd.points.first.y)
            cmd.absolute!(@program.pos) if cmd.relative?
            start = cmd
          when :line
            @program.cut!(cmd.points.first.x, cmd.points.first.y)
          when :cubic
            cubic!(cmd)
          when :close
            @program.cut!(start.points.first.x, start.points.first.y)
            start = nil
          end
        end
      end

      def metric?
        @metric
      end

      def finish
        unless @finished
          @program.home!
          @program.stop!
          @finished = true
        end
      end

      def to_s
        @program.to_s
      end

      private

      def cubic!(cmd)
        # SVG cubic bezier has all control points relative to start
        # g-code I&J are relative to start, and P&Q relative to end
        # I, J, P & Q are always relative, but SVG values can be absolute
        cmd.points[0] -= @program.pos if cmd.absolute?
        cmd.points[1] -= cmd.points[2]

        @program.cubic_spline!(
          cmd.points[0].x, cmd.points[0].y,
          cmd.points[1].x, cmd.points[1].y,
          cmd.points[2].x, cmd.points[2].y,
        )
      end
    end
  end
end
