require 'svgcode/gcode/program'
require 'svgcode/svg/path'

module Svgcode
  module GCode
    class Converter
      attr_reader :prog, :finished
      MM_PER_PX = 0.264583333 # 96 dpi

      def initialize
        @finished = false
        @prog = Program.new
        @prog.metric!
        @prog.feedrate!
        @prog.home!
      end

      def <<(svg_d)
        svg_start = nil
        path = SVG::Path.new(svg_d)
        start = nil
        is_absolute = false

        path.commands.each do |cmd|
          cmd.negate_points_y!          
          start = cmd if start.nil? && cmd.name != :move

          if (cmd.name == :close || cmd.absolute?) && !is_absolute
            @prog.absolute!
            is_absolute = true
          elsif is_absolute
            @prog.relative!
            is_absolute = false
          end

          case cmd.name
          when :move
            @prog.go!(cmd.points.first.x, cmd.points.first.y)
          when :line
            @prog.cut!(cmd.points.first.x, cmd.points.first.y)
          when :cubic
            cubic!(cmd)
          when :close
            @prog.cut!(start.points.first.x, -start.points.first.y)
          end
        end
      end

      def finish
        unless @finished
          @prog.home!
          @prog.stop!
          @finished = true
        end
      end

      def to_s
        @prog.to_s
      end

      private      

      def cubic!(cmd)
        start_pt = @prog.pos
        end_pt = cmd.points[2]
        ctrl_pt_1 = cmd.points[0].relative(start_pt)
        ctrl_pt_2 = cmd.points[1].relative(end_pt)

        @prog.cubic_spline!(
          ctrl_pt_1.x, ctrl_pt_1.y,
          ctrl_pt_2.x, ctrl_pt_2.y,
          end_pt.x, end_pt.y
        )
      end
    end
  end
end
