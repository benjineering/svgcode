require 'svgcode/svg/point'
require 'matrix'

module Svgcode
  module SVG
    class Transform
      attr_reader :a, :b, :c, :d, :e, :f

      def initialize(str_or_a, b = nil, c = nil, d = nil, e = nil, f = nil)
        if str_or_a.is_a?(String)
          raise ArgumentException.new unless str_or_a.start_with?('matrix')
          nums = str_or_a.gsub(/.+\(/, '').gsub(/\)/, '').split(/\s*,\s*/)

          nums.each_with_index do |n, i|
            case i
            when 0
              @a = n.to_f
            when 1
              @b = n.to_f
            when 2
              @c = n.to_f
            when 3
              @d = n.to_f
            when 4
              @e = n.to_f
            when 5
              @f = n.to_f
            end
          end
        else
          @a = str_or_a.to_f
          @b = b.to_f
          @c = c.to_f
          @d = d.to_f
          @e = e.to_f
          @f = f.to_f
        end
      end

      def to_matrix
        Matrix[[@a, @c, @e], [@b, @d, @f], [0, 0, 1]]
      end

      def apply(point)
        point_m = Matrix[[point.x], [point.y], [1]]
        transform_m = to_matrix
        result = transform_m * point_m
        Point.new(result[0, 0], result[1, 0])
      end
    end
  end
end
