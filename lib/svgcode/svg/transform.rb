require 'svgcode/svg/point'
require 'matrix'

module Svgcode
  module SVG
    class Transform
      attr_reader :a, :b, :c, :d, :e, :f

      def initialize(str)
        raise ArgumentException.new unless str.start_with?('matrix')
        nums = str.gsub(/.+\(/, '').gsub(/\)/, '').split(/\s*,\s*/)

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
      end

      def apply(point)
        point_m = Matrix[[point.x], [point.y], [1]]
        transform_m = Matrix[[@a, @c, @e], [@b, @d, @f], [0, 0, 1]]
        result = transform_m * point_m
        Point.new(result[0, 0], result[1, 0])
      end
    end
  end
end
