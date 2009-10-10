#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

g = nil
if ARGV[0]
  g = GraphViz::new( "structs", "type" => "graph", "path" => ARGV[0] )
else
  g = GraphViz::new( "structs", "type" => "graph" )
end

main        = g.add_node( "main" )
parse       = g.add_node( "parse" )
execute     = g.add_node( "execute" )
init        = g.add_node( "init" )
cleanup     = g.add_node( "cleanup" )
make_string = g.add_node( "make_string" )
printf      = g.add_node( "printf" )
compare     = g.add_node( "compare" )

g.add_edge( main, parse )
g.add_edge( parse, execute )
g.add_edge( main, init )
g.add_edge( main, cleanup )
g.add_edge( execute, make_string )
g.add_edge( execute, printf )
g.add_edge( init, make_string )
g.add_edge( main, printf )
g.add_edge( execute, compare )

g.output( :png => "#{$0}.png" )
