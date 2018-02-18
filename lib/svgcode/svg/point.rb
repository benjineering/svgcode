module Svgcode
  module SVG
    class Point
      attr_reader :x, :y

      VALUE_SEP = /\s?,\s?/
      OBJECT_SEP = /\s+/

      def initialize(str_or_x, y = nil)
        if y.nil?
          parts = str_or_x.split(VALUE_SEP)
          @x = Point.str_to_f(parts.first)
          @y = Point.str_to_f(parts.last)
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

      def +(point_or_num)
        if point_or_num.is_a?(Point)
          Point.new(@x + point_or_num.x, @y + point_or_num.y)
        else
          Point.new(@x + point_or_num, @y + point_or_num)
        end
      end

      def -(point_or_num)
        if point_or_num.is_a?(Point)
          Point.new(@x - point_or_num.x, @y - point_or_num.y)
        else
          Point.new(@x - point_or_num, @y - point_or_num)
        end
      end

      def *(point_or_num)
        if point_or_num.is_a?(Point)
          Point.new(@x / point_or_num.x, @y / point_or_num.y)
        else
          Point.new(@x / point_or_num, @y / point_or_num)
        end
      end

      def /(point_or_num)
        if point_or_num.is_a?(Point)
          Point.new(@x / point_or_num.x, @y / point_or_num.y)
        else
          Point.new(@x / point_or_num, @y / point_or_num)
        end
      end

      def divide_by!(amount)
        @x /= amount
        @y /= amount
      end

      def flip_y!(max_y)
        @y = max_y - @y
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

      def self.str_to_f(str)
        str.include?('e') ? "%f" % str : str.to_f
      end
    end
  end
end
