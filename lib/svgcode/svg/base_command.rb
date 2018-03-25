require 'svgcode/svg/point'

module Svgcode
  module SVG
    class BaseCommand
      attr_reader :name, :absolute, :points

      NAMES = {
        'm' => :move,
        'l' => :line,
        'c' => :cubic,
        'z' => :close
      }

      def initialize(opts)
        @name = opts[:name]
        @absolute = !!opts[:absolute]
        @points = opts[:points] || []
      end

      def absolute?
        @absolute
      end

      def relative?
        !@absolute
      end

      def absolute(pos)
        points = @points.collect { |p| p + pos }
        Command.new(name: @name, absolute: true, points: points)
      end

      def absolute!(pos)
        if relative?
          @points.collect! { |p| p + pos }
          @absolute = true
        end
      end

      def negate_points_y
        points = @points.collect { |point| point.negate_y }
        Command.new(name: @name, absolute: @absolute, points: points)
      end

      def negate_points_y!
        @points.each { |point| point.negate_y! }
        nil
      end

      def divide_points_by!(amount)
        @points.each { |point| point.divide_by!(amount) }
        nil
      end

      def flip_points_y!(max_y)
        @points.each { |point| point.flip_y!(max_y) }
        nil
      end

      def apply_transforms!(transforms)
        unless transforms.empty?
          transforms.reverse.each do |transform|
            @points.collect! { |point| transform.apply(point) }
          end
        end
      end

      def name_str
        Command.name_str(@name, absolute?)
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.name == @name &&
          other.absolute? == @absolute &&
          other.points == @points
      end

      def to_s
        name_str + @points.collect { |p| p.to_s }.join(' ')
      end

      def self.name_str(sym, absolute)
        str = NAMES.key(sym).dup
        str.upcase! if absolute
        str
      end
    end
  end
end
