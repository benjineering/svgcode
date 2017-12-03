require 'svgcode/svg/point'

module Svgcode
  module SVG
    class Command
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
          @absolute = !!str[0].match(/[A-Z]/)
          @name = NAMES[str[0].to_s.downcase]

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

      def negate_points_y
        points = @points.collect { |point| point.negate_y }
        Command.new(name: @name, absolute: @absolute, points: points)
      end

      def negate_points_y!
        @points.each { |point| point.negate_y! }
        nil
      end

      def ==(other)
        other.is_a?(self.class) && 
          other.name == @name && 
          other.absolute == @absolute && 
          other.points == @points
      end

      def self.name_str(sym, absolute)
        str = NAMES.key(sym).dup
        str.upcase! if absolute
        str
      end
    end
  end
end
