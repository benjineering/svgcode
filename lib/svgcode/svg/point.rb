module Svgcode
  module SVG
    class Point
      attr_reader :x, :y

      VALUE_SEP = /\s?,\s?/
      OBJECT_SEP = /\b\s+\b/

      def initialize(str_or_x, y = nil)
        if y.nil?
          parts = str_or_x.split(VALUE_SEP)
          @x = parts.first.to_f
          @y = parts.last.to_f
        else
          @x = str_or_x.to_f
          @y = y.to_f
        end
      end

      def ==(other)
        other.is_a?(self.class) && other.x.eql?(@x) && other.y.eql?(@y)
      end

      def self.parse(str)
        str.split(OBJECT_SEP).collect { |p| Point.new(p) }
      end
    end
  end
end
