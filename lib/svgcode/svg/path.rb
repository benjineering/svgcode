require 'svgcode/svg/command'

module Svgcode
  module SVG
    class Path
      attr_reader :commands

      def initialize(str)
        @commands = str.split(/(?=[a-z])/i).collect { |s| Command.new(s) }
      end
    end
  end
end
