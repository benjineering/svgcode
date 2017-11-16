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
        @prog.absolute!
        @prog.feedrate!
        @prog.home!
      end

      def <<(svg_d)
        svg_start = nil
        path = SVG::Path.new(svg_d)
        start = nil

        path.commands.each do |svg|
          start = svg if start.nil? && svg.name != :move

          case svg.name
          when :move
            @prog.go!(mm(svg.points.first.x), mm(-svg.points.first.y))
          when :line
            @prog.cut!(mm(svg.points.first.x), mm(-svg.points.first.y))
          when :cubic
            @prog.cubic_spline!(
              mm(svg.points[0].x), mm(-svg.points[0].y),
              mm(svg.points[1].x), mm(-svg.points[1].y),
              mm(svg.points[2].x), mm(-svg.points[2].y)
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
