require 'svgcode/svg/point'
require 'svgcode/svg/base_command'

module Svgcode
  module SVG
    class PathCommand < BaseCommand
      attr_reader :name, :absolute, :points

      NAMES = {
        'm' => :move,
        'l' => :line,
        'c' => :cubic,
        'z' => :close
      }

      def initialize(str_or_opts)
        if str_or_opts.is_a?(Hash)
          @name = str_or_opts[:name]
          @absolute = !!str_or_opts[:absolute]
          @points = str_or_opts[:points]
        else
          str = str_or_opts
          @name = NAMES[str[0].to_s.downcase]

          @absolute =
          if @name == :close
            true
          else
            !!str[0].match(/[A-Z]/)
          end

          if @name != :close && str.length > 1
            @points = Point.parse(str[1..(str.length - 1)])
          end
        end

        @points = [] if @points.nil?
      end

      def absolute?
        @absolute
      end

      def relative?
        !@absolute
      end

      def absolute(pos)
        points = @points.collect { |p| p + pos }
        PathCommand.new(name: @name, absolute: true, points: points)
      end

      def absolute!(pos)
        if relative?
          @points.collect! { |p| p + pos }
          @absolute = true
        end
      end

      def negate_points_y
        points = @points.collect { |point| point.negate_y }
        PathCommand.new(name: @name, absolute: @absolute, points: points)
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
        PathCommand.name_str(@name, absolute?)
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
