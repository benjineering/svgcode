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
            @prog.go!(mm(cmd.points.first.x), mm(-cmd.points.first.y))
          when :line
            @prog.cut!(mm(cmd.points.first.x), mm(-cmd.points.first.y))
          when :cubic
            @prog.cubic_spline!(
              mm(cmd.points[0].x), mm(-cmd.points[0].y),
              mm(cmd.points[1].x), mm(-cmd.points[1].y),
              mm(cmd.points[2].x), mm(-cmd.points[2].y)
            )
          when :close
            @prog.cut!(mm(start.points.first.x), mm(-start.points.first.y))
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

      def mm(px)
        px #* MM_PER_PX
      end

      def to_s
        @prog.to_s
      end
    end
  end
end
