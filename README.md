# Svgcode
A Ruby Gem for transposing SVG into G-code.

It is specifically designed to take advantage of the link between SVG's bezier
curves and LinuxCNC's
[G5](http://linuxcnc.org/docs/2.6/html/gcode/gcode.html#sec:G5-Cubic-Spline)
command.

It has been fairly thorougly tested with SVGs exported from Affinity Designer,
though you will need to check the "Export text as curves for font independence"
option as the SVG text element is currently not handled.

Also, you must ensure that the DPI is set to 300 when exporting.

Other SVG features which are yet to be handled:
- horizontal and vertical lines
- quadratic bezier curves
- arcto
- non-matrix transforms

For more temporary shortcomings, please see TODO.md.

## Installation
`gem install svgcode`

## Usage
### CLI
To display usage:
    
    svgcode help parse # see bin/svgcode

### API
Docs to come.
