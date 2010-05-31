$:.unshift( "../lib" );
require "graphviz"

g = GraphViz::new( "G", :type => "graph" )
n1 = g.add_node( "A" )
n2 = g.add_node( "B" )
n3 = g.add_node( "C" )
e1 = g.add_edge( n1, n2 )
e1[:dir] = 'forward'
e2 = g.add_edge( n1, n3 )
g.output( :png => "#{$0}.png" )