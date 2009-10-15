#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

g = nil
if ARGV[0]
  g = GraphViz::new( "G", "path" => ARGV[0] )
else
  g = GraphViz::new( "G" )
end

g.node["color"] = "black"

g.edge["color"] = "black"
g.edge["weight"] = "1"
g.edge["style"] = "filled"
g.edge["label"] = ""

g["size"] = "4,4"

g.node["shape"] = "box"
main        = g.add_node( "main" )
g.node["shape"] = "ellipse"
parse       = g.add_node( "parse" )
execute     = g.add_node( "execute" )
init        = g.add_node( "init" )
cleanup     = g.add_node( "cleanup" )
make_string = g.add_node( "make_string", "label" => 'make a\nstring' )
printf      = g.add_node( "printf" )
compare     = g.add_node( "compare", "shape" => "box", "style" => "filled", "color" => ".7 .3 1.0" )

g.add_edge( main, parse, "weight" => "8" )
g.add_edge( parse, execute )
g.add_edge( main, init, "style" => "dotted" )
g.add_edge( main, cleanup )
g.add_edge( execute, make_string )
g.add_edge( execute, printf )
g.add_edge( init, make_string )
g.add_edge( main, printf, "color" => "red", "style" => "bold", "label" => "100 times" )
g.add_edge( execute, compare, "color" => "red" )

g.output( :png => "#{$0}.png" )
