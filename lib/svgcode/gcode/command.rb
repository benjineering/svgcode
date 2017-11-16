module Svgcode
  module GCode
    class Command
      attr_accessor :letter, :number, :args

      SEP = /(?=[a-z])/i

      def initialize(str_or_sym = nil, number = nil, args = [])
        if str_or_sym.is_a?(String)
          parts = str_or_sym.split(/\s+/)
          cmd = Command.parse(parts.shift)
          @letter = cmd.letter
          @number = cmd.number
          parts.each { |arg| @args << Command.parse(arg) }
        
        elsif str_or_sym.is_a?(Symbol)
          @letter = str_or_sym
          @number = number
          @args = args
        end

        @letter = @letter.to_s.upcase
      end

      def to_s
        num_fmt = @letter == 'M' || @letter == 'G' ? "%02d" : "%.3f"
        num = num_fmt % @number
        str = "#{@letter}#{num}"
        str += " #{@args.join(' ')}" unless @args.nil? || @args.empty?
        str
      end

      def self.parse(single_command_str)
        str = single_command_str.split(SEP)
        cmd = Command.new
        cmd.letter = cmd.first
        cmd.number = cmd.last.to_f
        cmd
      end

      def self.absolute
        Command.new(:g, 90)
      end

      def self.metric
        Command.new(:g, 21)
      end

      def self.home
        Command.new(:g, 30)
      end

      def self.stop
        Command.new(:m, 2)
      end

      def self.feedrate(rate)
        Command.new(:f, rate)
      end

      def self.go(x, y)
        Command.new(:g, 0, [
          Command.new(:x, x),
          Command.new(:y, y)
        ])
      end

      def self.cut(x, y)
        Command.new(:g, 1, [
          Command.new(:x, x),
          Command.new(:y, y)
        ])
      end

      def self.cubic_spline(i, j, p_, q, x, y)
        Command.new(:g, 5, [
          Command.new(:i, i),
          Command.new(:j, j),
          Command.new(:p, p_),
          Command.new(:q, q),
          Command.new(:x, x),
          Command.new(:y, y)
        ])
      end

      def self.clear(clearance)
        Command.new(:g, 0, [
          Command.new(:z, clearance)
        ])
      end

      def self.plunge(depth)
        Command.new(:g, 1, [
          Command.new(:z, depth)
        ])
      end
    end
  end
end
