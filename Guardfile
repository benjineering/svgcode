require 'svgcode/cli'
require 'tempfile'

guard :shell do
  watch(//) do |mod|
    ngc_file = Tempfile.new
    cli = Svgcode::CLI.new

    cli.invoke('parse', ['~/Desktop/azabache.svg'],
      out_path: ngc_file.path,
      comments: true
    )

    cli.invoke('post', [ngc_file.path])
  end
end
