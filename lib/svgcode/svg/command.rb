require 'svgcode/svg/point'

module Svgcode
  module SVG
    class Command
      attr_reader :name, :points, :absolute

      CMDS = {
        'm' => :move,
        'l' => :line,
        'c' => :cubic,
        'z' => :close
      }

      def initialize(str_or_name, absolute = nil, points = nil)
        if str_or_name.is_a?(Symbol)
          @name = str_or_name
          @absolute = !!absolute
          @points = points
        else
          str = str_or_name
          @absolute = !!str[0].match(/[A-Z]/)
          @name = CMDS[str[0].to_s.downcase]
          @points = Point.parse(str[1..(str.length - 1)]) unless str.length < 2
        end

        @points = [] if @points.nil?
      end

      def absolute?
        @absolute
      end

      def relative?
        !@absolute
      end
    end
  end
end
