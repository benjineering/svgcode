require 'svgcode'
require 'thor'
require 'net/http'

module Svgcode
  class CLI < Thor
    DEFAULT_POST_URL = 'http://linux-cnc.bmo:8080'
    DEFAULT_POST_NAME = 'file'

    desc 'parse SVG_PATH [--out OUT_PATH] [--comments]',
      'parses an SVG file to a G-code file'
    option :out_path
    option :comments, type: :boolean
    long_desc <<-LONGDESC
      `svgcode parse ~/Desktop/img.svg` will save the G-code file as
      '~/Desktop/img.ngc'.

      Optionally set the --out-path flag to save the G-code file elsewhere
      \x5 e.g. `svgcode parse ~/Documents/img.svg --out-path ~/Desktop/gcode.nc`

      Optionally pass the --comments flag to print SVG IDs as comments
      \x5 e.g. `svgcode parse --comments ~/Desktop/img.svg`
    LONGDESC
    def parse(in_path)
      in_path = File.expand_path(in_path)
      raise "#{in_path} is not readable" unless File.readable?(in_path)
      svg_str = File.read(in_path)

      out_path =
      if options[:out_path].nil?
        in_path.gsub(/\.svg\Z/i, '.ngc')
      else
        File.expand_path(options[:out_path])
      end

      opts = { comments: options[:comments] }
      File.open(out_path, 'w') { |f| f << Svgcode.parse(svg_str, opts) }

      puts "G-code written to #{out_path}"
    end

    desc 'post NGC_PATH [--url URL] [--post-name POST_NAME]',
      'posts an GCode file to a server'
    option :url, default: DEFAULT_POST_URL
    option :post_name, default: DEFAULT_POST_NAME
    long_desc <<-LONGDESC
      `svgcode post ~/Desktop/img.ngc` will post the GCode file to
      #{DEFAULT_POST_URL}.

      Optionally set the --url flag to post the GCode file elsewhere
      \x5 e.g. `svgcode post ~/Documents/img.ngc --url http://192.168.20.7:9999`

      Optionally pass the --post-name flag to name the file field something other
      than the default '#{DEFAULT_POST_NAME}'
      \x5 e.g. `svgcode post --post-name svgfile`
    LONGDESC
    def post(ngc_path)
      ngc_path = File.expand_path(ngc_path)
      raise "#{ngc_path} is not readable" unless File.readable?(ngc_path)

      uri = URI(options[:url])
      request = Net::HTTP::Post.new(uri)
      form_data = [[options[:post_name], File.open(ngc_path)]]
      message = nil

      request.set_form form_data, 'multipart/form-data'
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      puts response

      puts "G-code posted to #{options[:url]}"
    end
  end
end
