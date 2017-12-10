require 'svgcode/version'
require 'svgcode/gcode/converter'
require 'svgcode/svg/transform'
require 'nokogiri'

Converter = Svgcode::GCode::Converter
Transform = Svgcode::SVG::Transform

module Svgcode
  def self.parse(xml_str)
    doc = Nokogiri.parse(xml_str)
    doc.remove_namespaces!

    view_box = doc.xpath('/svg').first.attributes['viewBox'].value
    max_y = view_box.split(/\s+/).last.to_f
    converter = Converter.new(max_y: max_y)

    doc.xpath('//path').each do |path|
      converter.transforms = path.xpath('ancestor::g[@transform]').collect do |t|
        Transform.new(t.attributes['transform'].value)
      end

      converter << path.attributes['d'].value
    end

    converter.finish
    converter.to_s
  end
end
