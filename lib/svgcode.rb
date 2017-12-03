require 'svgcode/version'
require 'svgcode/gcode/converter'
require 'nokogiri'

module Svgcode
  def self.parse(xml_str)
    doc = Nokogiri.parse(xml_str)
    doc.remove_namespaces!

    view_box = doc.xpath('/svg').first.attributes['viewBox'].value
    max_y = view_box.split(/\s+/).last.to_f
    converter = GCode::Converter.new(max_y: max_y)

    doc.xpath('//path').each do |path|
      converter << path.attributes['d'].value
    end

    converter.finish
    converter.to_s
  end
end
