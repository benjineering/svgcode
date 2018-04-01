require 'svgcode/utility'
require 'svgcode/svg/base_command'
require 'svgcode/svg/point'
require 'nokogiri'

module Svgcode
  module SVG
    class Circle < BaseCommand
      attr_reader :centre_x, :centre_y, :radius

      def initialize(element_or_x, y = nil, r = nil)
        @name = :circle
        @absolute = true

        if element_or_x.is_a?(Nokogiri::XML::Element)
          @centre_x = Utility.x_to_f(element_or_x.attributes['cx'].value)
          @centre_y = Utility.x_to_f(element_or_x.attributes['cy'].value)
          @radius = Utility.x_to_f(element_or_x.attributes['r'].value)
        else
          @centre_x = Utility.x_to_f(element_or_x)
          @centre_y = Utility.x_to_f(y)
          @radius = Utility.x_to_f(r)
        end

        @points = [ Point.new(@centre_x, @centre_y) ]
      end

      def start_x
        @centre_x - @radius
      end

      def apply_transforms!(transforms)
        super(transforms)

        transforms.reverse.each do |transform|
          r_start = transform.apply(Point.new(start_x, 0))
          r_end = transform.apply(Point.new(@centre_x, 0))
          @centre_x = r_end.x
          @radius = @centre_x - r_start.x
        end

        @centre_x = @points.first.x
        @centre_y = @points.first.y
      end

      def divide_points_by!(amount)
        super(amount)
        @centre_x = @points.first.x
        @centre_y = @points.first.y
        @radius /= amount
      end
    end
  end
end
