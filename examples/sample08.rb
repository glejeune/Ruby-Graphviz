#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

g = nil
if ARGV[0]
  g = GraphViz::new( "G" "nodesep" => ".05", "rankdir" => "LR", "path" => ARGV[0] )
else
  g = GraphViz::new( "G", "nodesep" => ".05", "rankdir" => "LR" )
end

g.node["shape"] = "record"
g.node["width"] = ".1"
g.node["height"] = ".1"

g.add_node( "node0", "label" => "<f0> |<f1> |<f2> |<f3> |<f4> |<f5> |<f6> |<f7> | ", "height" => "2.5" )
g.add_node( "node1", "label" => "{<n> n14 | 719 |<p> }", "width" => "1.5" )
g.add_node( "node2", "label" => "{<n> a1 | 805 |<p> }", "width" => "1.5" )
g.add_node( "node3", "label" => "{<n> i9 | 718 |<p> }", "width" => "1.5" )
g.add_node( "node4", "label" => "{<n> e5 | 989 |<p> }", "width" => "1.5" )
g.add_node( "node5", "label" => "{<n> t20 | 959 |<p> }", "width" => "1.5" )
g.add_node( "node6", "label" => "{<n> o15 | 794 |<p> }", "width" => "1.5" )
g.add_node( "node7", "label" => "{<n> s19 | 659 |<p> }", "width" => "1.5" )

g.add_edge( {"node0" => :f0}, {"node1" => :n} )
g.add_edge( {"node0" => :f1}, {"node2" => :n} )
g.add_edge( {"node0" => :f2}, {"node3" => :n} )
g.add_edge( {"node0" => :f5}, {"node4" => :n} )
g.add_edge( {"node0" => :f6}, {"node5" => :n} )
g.add_edge( {"node2" => :p}, {"node6" => :n} )
g.add_edge( {"node4" => :p}, {"node7" => :n} )

g.output( :png => "#{$0}.png" )
