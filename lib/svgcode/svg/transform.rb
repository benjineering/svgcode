require 'svgcode/utility'
require 'svgcode/svg/point'
require 'matrix'

module Svgcode
  module SVG
    class Transform
      attr_reader :a, :b, :c, :d, :e, :f

      def initialize(str_or_a, b = nil, c = nil, d = nil, e = nil, f = nil)
        if str_or_a.is_a?(String)
          raise ArgumentError.new unless str_or_a.start_with?('matrix')
          nums = str_or_a.gsub(/.+\(/, '').gsub(/\)/, '').split(/\s*,\s*/)

          nums.each_with_index do |n, i|
            case i
            when 0
              @a = Svgcode::Utility.x_to_f(n)
            when 1
              @b = Svgcode::Utility.x_to_f(n)
            when 2
              @c = Svgcode::Utility.x_to_f(n)
            when 3
              @d = Svgcode::Utility.x_to_f(n)
            when 4
              @e = Svgcode::Utility.x_to_f(n)
            when 5
              @f = Svgcode::Utility.x_to_f(n)
            end
          end
        else
          @a = Svgcode::Utility.x_to_f(str_or_a)
          @b = Svgcode::Utility.x_to_f(b)
          @c = Svgcode::Utility.x_to_f(c)
          @d = Svgcode::Utility.x_to_f(d)
          @e = Svgcode::Utility.x_to_f(e)
          @f = Svgcode::Utility.x_to_f(f)
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
