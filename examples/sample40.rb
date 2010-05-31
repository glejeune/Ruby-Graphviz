$:.unshift( "../lib" );
require "graphviz"

graph = GraphViz.new( :G, :type => :digraph )

node1 = graph.add_node("A1", 
  "shape" => "record", 
  "label" => "<left>|<f1> 1|<right>" )

node2 = graph.add_node("A2", 
  "shape" => "record", 
  "label" => "<left>|<f1> 2|<right>" )

graph.add_edge(node1.id + ":left", node2)

graph.output( :png => "#{$0}.png" )
