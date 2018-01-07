module Svgcode
  module GCode
    class Command
      INT_FORMAT = "%02d"
      FLOAT_FORMAT = "%.3f"
      INT_LETTERS = [ 'M', 'G' ]

      attr_reader :letter, :number, :args

      def initialize(letter_or_str = nil, number = nil, args = [])
        if letter_or_str.length > 1
          parts = letter_or_str.split(/\s+/)
          cmd = Command.parse_single(parts.shift)
          @letter = cmd.letter
          @number = cmd.number
          @args = parts.collect { |arg| Command.parse_single(arg) }        
        else
          @letter = letter_or_str
          @number = number
          @args = args
        end

        @letter = @letter.to_s.upcase
        @number = @number.to_f unless @number.nil?
      end

      def to_s
        num_fmt = INT_LETTERS.include?(@letter) ? INT_FORMAT : FLOAT_FORMAT
        str = "#{@letter}#{num_fmt % @number}"
        str += " #{@args.join(' ')}" unless @args.nil? || @args.empty?
        str
      end

      def ==(other)
        other.is_a?(self.class) && 
          other.letter == @letter &&
          other.number.eql?(@number) &&
          other.args == @args
      end

      def roughly_equal?(other)
        return false unless @letter == other.letter
        return false unless @args.length == other.args.length
        return @number == other.number unless @number.nil? || other.number.nil?

        result = true
        @args.each_with_index do |arg, i|
          unless arg.roughly_equal?(other.args[i])
            result = false
            break
          end
        end

        result
      end

      def self.parse_single(str)
        letter = str[0].to_sym
        number = str.length > 1 ? str[1..(str.length - 1)] : nil
        Command.new(letter, number)
      end

      def self.comment(str)
        "\n(#{str}!!!)"
      end

      def self.absolute
        Command.new(:g, 90)
      end

      def self.relative
        Command.new(:g, 91)
      end

      def self.metric
        Command.new(:g, 21)
      end

      def self.imperial
        Command.new(:g, 20)
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

      def self.g(number, args = nil)
        Command.new(:g, number, args)
      end

      def self.m(number, args = nil)
        Command.new(:m, number, args)
      end
    end
  end
end
