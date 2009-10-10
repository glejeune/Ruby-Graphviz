#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

g = nil
if ARGV[0]
  g = GraphViz::new( "G", "path" => ARGV[0] )
else
  g = GraphViz::new( "G" )
end

g.node["shape"] = "ellipse"
g.node["sides"] = "4"
g.node["peripheries"] = ""
g.node["color"] = "black"
g.node["style"] = ""
g.node["skew"] = "0.0"
g.node["distortion"] = "0.0"

a = g.add_node( "a", "shape" => "polygon", "sides" => "5", "peripheries" => "3", "color" => "lightblue", "style" => "filled"  )
b = g.add_node( "b" )
c = g.add_node( "c", "shape" => "polygon", "sides" => "4", "skew" => ".4", "label" => "hello world" )
d = g.add_node( "d", "shape" => "invtriangle" )
e = g.add_node( "e", "shape" => "polygon", "sides" => "4", "distortion" => ".7" )

g.add_edge( a, b )
g.add_edge( b, c )
g.add_edge( b, d )

g.output( :png => "#{$0}.png" )
