#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

graph = nil
if ARGV[0]
  graph = GraphViz::new( "G", "path" => ARGV[0] )
else
  graph = GraphViz::new( "G" )
end

graph["compound"] = "true"
graph.edge["lhead"] = ""
graph.edge["ltail"] = ""

c0 = graph.add_graph( "cluster0" )
a = c0.add_node( "a" )
b = c0.add_node( "b" )
c = c0.add_node( "c" )
d = c0.add_node( "d" )
c0.add_edge( a, b )
c0.add_edge( a, c )
c0.add_edge( b, d )
c0.add_edge( c, d )

c1 = graph.add_graph( "cluster1" )
e = c1.add_node( "e" )
f = c1.add_node( "f" )
g = c1.add_node( "g" )
c1.add_edge( e, g )
c1.add_edge( e, f )

h = graph.add_node( "h" )

graph.add_edge( b, f, "lhead" => "cluster1" )
graph.add_edge( d, e )
graph.add_edge( c, g, "ltail" => "cluster0", "lhead" => "cluster1" )
graph.add_edge( c, e, "ltail" => "cluster0" )
graph.add_edge( d, h )

graph.output( :png => "#{$0}.png" )
