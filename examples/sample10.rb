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
g.node["color"] = "black"

g["color"] = "black"

c0 = g.add_graph( "cluster0" )
c0["label"] = "process #1"
c0["style"] = "filled"
c0["color"] = "lightgrey"
a0 = c0.add_node( "a0", "style" => "filled", "color" => "white" )
a1 = c0.add_node( "a1", "style" => "filled", "color" => "white" )
a2 = c0.add_node( "a2", "style" => "filled", "color" => "white" )
a3 = c0.add_node( "a3", "style" => "filled", "color" => "white" )
c0.add_edge( a0, a1 )
c0.add_edge( a1, a2 )
c0.add_edge( a2, a3 )

c1 = g.add_graph( "cluster1", "label" => "process #2" )
b0 = c1.add_node( "b0", "style" => "filled", "color" => "blue" )
b1 = c1.add_node( "b1", "style" => "filled", "color" => "blue" )
b2 = c1.add_node( "b2", "style" => "filled", "color" => "blue" )
b3 = c1.add_node( "b3", "style" => "filled", "color" => "blue" )
c1.add_edge( b0, b1 )
c1.add_edge( b1, b2 )
c1.add_edge( b2, b3 )

start = g.add_node( "start", "shape" => "Mdiamond" )
endn  = g.add_node( "end",   "shape" => "Msquare" )

g.add_edge( start, a0 )
g.add_edge( start, b0 )
g.add_edge( a1, b3 )
g.add_edge( b2, a3 )
g.add_edge( a3, a0 )
g.add_edge( a3, endn )
g.add_edge( b3, endn )

g.output( :png => "#{$0}.png" )
