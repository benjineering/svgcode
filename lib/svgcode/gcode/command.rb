module Svgcode
  module GCode
    class Command
      attr_reader :letter, :number, :args

      def initialize(str_or_sym = nil, number = nil, args = [])
        if number.nil?
          parts = str_or_sym.split(/\s+/)
          cmd = Command.parse_single(parts.shift)
          @letter = cmd.letter
          @number = cmd.number
          @args = parts.collect { |arg| Command.parse_single(arg) }        
        else
          @letter = str_or_sym
          @number = number
          @args = args
        end

        @letter = @letter.to_s.upcase
        @number = @number.to_f
      end

      def self.parse_single(str)
        letter = str[0].to_sym
        number = str.length > 1 ? str[1..(str.length - 1)] : nil
        Command.new(letter, number)
      end

      def to_s
        num_fmt = @letter == 'M' || @letter == 'G' ? "%02d" : "%.3f"
        num = num_fmt % @number
        str = "#{@letter}#{num}"
        str += " #{@args.join(' ')}" unless @args.nil? || @args.empty?
        str
      end

      def ==(other)
        other.is_a?(self.class) && 
          other.letter == @letter &&
          other.number.eql?(@number) &&
          other.args == @args
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

      def self.cubic_spline(i, j, _p, q, x, y)
        Command.new(:g, 5, [
          Command.new(:i, i),
          Command.new(:j, j),
          Command.new(:p, _p),
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
