require 'svgcode/svg/point'

module Svgcode
  module SVG
    class Command
      attr_reader :name, :points

      CMDS = {
        'M' => :move,
        'L' => :line,
        'C' => :cubic,
        'Z' => :close
      }

      def initialize(str)
        @name = CMDS[str[0].to_s.upcase]
        @points = Point.parse(str[1..(str.length - 1)]) unless str.length < 2
      end

      def to_s
        s = "#{@name}"
        s += " #{@points.join(' ')}" unless @points.nil? || @points.empty?
        s
      end
    end
  end
end
