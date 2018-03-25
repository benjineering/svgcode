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
    end
  end
end
