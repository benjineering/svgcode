## TODO
- handle transform matrices
- handle horizontal and vertical lines
- handle quadratic bezier curves
- handle arcto
- move converter out of GCode module
- fix Point
  - make base Point class
  - make GCode point class
    - convert between the two
    - use in Program

# TODO LATER
- create `add_commands` matcher for g-code program specs
  - accepts a block
  - diffable output
- print GCode desciptions and SVG IDs as options
- write docs
- better end to end tests
  - maybe include LinuxCNC
- cut to depth in multiple passes
- v-engrave filled areas
