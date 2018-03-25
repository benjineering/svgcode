module Svgcode
  module Utility
    SCI_SEP = /e/i

    def self.x_to_f(x)
      f =
      if x.is_a?(Numeric)
        x.to_f
      elsif x.is_a?(String)
        if x.match(SCI_SEP)
          parts = x.split(SCI_SEP)

          unless parts.length == 2
            raise ArgumentError.new('x is an unknown number format')
          end

          parts.first.to_f * 10.0 ** parts.last.to_f
        else
          x.to_f
        end
      else
        raise ArgumentError.new('x must be a Numeric or a String')
      end

      f
    end
  end
end
