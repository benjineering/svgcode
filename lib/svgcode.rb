require 'svgcode/version'
require 'svgcode/gcode/converter'
require 'nokogiri'

module Svgcode
  def self.parse(xml_str)
    doc = Nokogiri.parse(xml_str)
    doc.remove_namespaces!
    c = GCode::Converter.new

    doc.xpath('//path').each do |path|
      c << path.attributes['d'].value
    end

    c.finish
    c.to_s
  end
end
