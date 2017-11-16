module Svgcode
  module SVG
    class Point
      attr_accessor :x, :y

      SEP = /[,\s]/

      def initialize(str_or_x, y = nil)
        if y.nil?
          parts = str_or_x.split(SEP)
          @x = parts.first.to_f
          @y = parts.last.to_f
        else
          @x = str_or_x.to_f
          @y = y.to_f
        end
      end

      def self.parse(str)
        str.split(SEP).each_slice(2).collect { |a| Point.new(a.first, a.last) }
      end

      def to_s
        "#{@x} #{@y}"
      end
    end
  end
end
