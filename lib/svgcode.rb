require 'svgcode/version'
require 'svgcode/gcode/converter'
require 'svgcode/svg/transform'
require 'nokogiri'

Converter = Svgcode::GCode::Converter
Transform = Svgcode::SVG::Transform

module Svgcode
  def self.parse(xml_str, opts = {})
    doc = Nokogiri.parse(xml_str)
    doc.remove_namespaces!

    view_box = doc.xpath('/svg').first.attributes['viewBox'].value
    opts[:max_y] = view_box.split(/\s+/).last.to_f
    converter = Converter.new(opts)

    doc.xpath('//path').each do |path|
      if opts[:comments]
        ids = path.xpath('ancestor::g[@id]').collect do |t|
          t.attributes['id'].value
        end

        converter.comment!(ids.join(' '))
      end

      converter.transforms = path.xpath('ancestor::g[@transform]').collect do |t|
        Transform.new(t.attributes['transform'].value)
      end

      converter << path.attributes['d'].value
    end

    converter.finish
    converter.to_s
  end
end
