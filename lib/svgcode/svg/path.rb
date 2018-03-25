require 'svgcode/svg/path_command'

module Svgcode
  module SVG
    class Path
      attr_reader :commands

      def initialize(str)
        @commands = str.split(/(?=[a-z])/i).collect { |s| PathCommand.new(s) }
      end
    end
  end
end
