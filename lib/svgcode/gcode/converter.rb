require 'svgcode/gcode/program'
require 'svgcode/svg/path'

module Svgcode
  module GCode
    class Converter
      PX_PER_INCH = 300
      PX_PER_MM = PX_PER_INCH / 25.4

      attr_accessor :transforms
      attr_reader :program, :finished, :metric, :max_y

      def initialize(opts)
        raise ArgumentError.new if opts.nil? || opts[:max_y].nil?
        @finished = false
        @transforms = []
        @max_y = opts.delete(:max_y)
        @program = Program.new(opts)
        @metric = opts[:metric] != false
        @metric ? @program.metric! : @program.imperial!
        @program.feedrate!
      end

      def <<(str_or_command)
        @start = nil

        if str_or_command.is_a?(String)
          path = SVG::Path.new(str_or_command)
          path.commands.each { |cmd| add_command(cmd)}
        else
          add_command(str_or_command)
        end
      end

      def metric?
        @metric
      end

      def comment!(str)
        @program.comment!(str)
      end

      def finish
        unless @finished
          @program.clear!
          @program.go!(0, 0)
          @program.stop!
          @finished = true
        end
      end

      def to_s
        @program.to_s
      end

      private

      def add_command(cmd)
        cmd.apply_transforms!(@transforms)
        cmd.absolute? ? cmd.flip_points_y!(@max_y) : cmd.negate_points_y!

        if metric?
          cmd.divide_points_by!(PX_PER_MM)
        else
          cmd.divide_points_by!(PX_PER_INCH)
        end

        if cmd.name == :close || cmd.absolute?
          @program.absolute!
        elsif cmd.relative?
          @program.relative!
        end

        case cmd.name
        when :move
          @start = cmd.relative? ? cmd.absolute(@program.pos) : cmd
          @program.go!(cmd.points.first.x, cmd.points.first.y)
        when :line
          @program.cut!(cmd.points.first.x, cmd.points.first.y)
        when :cubic
          cubic!(cmd)
        when :circle
          @program.go!(cmd.start_x, cmd.centre_y)
          @program.arc!(cmd.start_x, cmd.centre_y, cmd.radius)
        when :close
          @program.cut!(@start.points.first.x, @start.points.first.y)
          @start = nil
        end
      end

      def cubic!(cmd)
        # A relative SVG cubic bezier has all control points relative to start.
        # G-code I&J are relative to start, and P&Q relative to end.
        # I, J, P & Q are always relative, but SVG values can be absolute.
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
