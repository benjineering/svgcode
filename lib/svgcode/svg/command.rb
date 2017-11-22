require 'svgcode/svg/point'

module Svgcode
  module SVG
    class Command
      attr_reader :name, :absolute, :points

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

          if @name != :close && str.length > 1
            @points = Point.parse(str[1..(str.length - 1)])
          end
        end

        @points = [] if @points.nil?
      end

      def absolute?
        @absolute
      end

      def relative?
        !@absolute
      end

      def ==(other)
        other.name == @name && 
          other.absolute == @absolute && 
          other.points == @points
      end
    end
  end
end
