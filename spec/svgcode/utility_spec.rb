require 'spec_helper'

RSpec.describe Svgcode::Utility do
  describe '.x_to_f' do
    context 'a float is passed' do
      it 'rounds up to 3 decimal places' do
        expect(Svgcode::Utility.x_to_f(10.8735)).to eql 10.874
      end
    end

    context 'an integer is passed' do
      it 'converts to a float with 3 decimal places' do
        expect(Svgcode::Utility.x_to_f(8)).to eql 8.000
      end
    end

    context 'a float string is passed' do
      it 'converts to a float with 3 decimal places' do
        expect(Svgcode::Utility.x_to_f('15.15144')).to eql 15.151
      end
    end

    context 'a scientific notation string is passed i.e. 12e-13' do
      it 'converts to a float with 3 decimal places' do
        expect(Svgcode::Utility.x_to_f('12e-3')).to eq 0.012
      end
    end
  end
end
