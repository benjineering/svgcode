module Svgcode
  module SVG
    class Point
      attr_reader :x, :y

      VALUE_SEP = /\s?,\s?/
      OBJECT_SEP = /\s+/

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

      def negate_y
        Point.new(@x, -@y)
      end

      def negate_y!
        @y = -@y
      end

      def relative(other)
        Point.new(other.x - @x, other.y - @y)
      end

      def /(amount)
        Point.new(@x / amount, @y / amount)
      end

      def divide_by!(amount)
        @x /= amount
        @y /= amount
      end

      def ==(other)
        other.is_a?(self.class) && other.x.eql?(@x) && other.y.eql?(@y)
      end

      def to_s
        "#{@x},#{@y}"
      end

      def self.parse(str)
        str.split(OBJECT_SEP).collect { |p| Point.new(p.strip) }
      end
    end
  end
end
