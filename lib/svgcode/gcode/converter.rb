require 'svgcode/gcode/program'
require 'svgcode/svg/path'

module Svgcode
  module GCode
    class Converter
      attr_reader :program, :finished

      def initialize(opts = {})
        @finished = false
        @program = Program.new(opts)
        opts[:metric] == false ? @program.imperial! : @program.metric!
        @program.feedrate!
      end

      def <<(svg_d)
        svg_start = nil
        path = SVG::Path.new(svg_d)
        start = nil

        path.commands.each do |cmd|
          cmd.negate_points_y!          
          start = cmd if start.nil? && cmd.name != :move

          if cmd.absolute? && @program.relative?
            @program.absolute!
          elsif cmd.relative? && @program.absolute?
            @program.relative!
          end

          case cmd.name
          when :move
            @program.go!(cmd.points.first.x, cmd.points.first.y)
          when :line
            @program.cut!(cmd.points.first.x, cmd.points.first.y)
          when :cubic
            cubic!(cmd)
          when :close
            @program.cut!(start.points.first.x, start.points.first.y)
          end
        end
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
        start_pt = @program.pos
        end_pt = cmd.points[2]
        ctrl_pt_1 = cmd.points[0].relative(start_pt)
        ctrl_pt_2 = cmd.points[1].relative(end_pt)

        @program.cubic_spline!(
          ctrl_pt_1.x, ctrl_pt_1.y,
          ctrl_pt_2.x, ctrl_pt_2.y,
          end_pt.x, end_pt.y
        )
      end
    end
  end
end
