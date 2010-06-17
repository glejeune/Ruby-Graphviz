$:.unshift( "../lib" );
require "graphviz"

graph = GraphViz.new( :G, :type => :digraph )

node1 = graph.add_node("hello:world", 
  "shape" => "record", 
  "label" => "<left>|<f1> 1|<right>" )

node2 = graph.add_node("2", 
  "shape" => "record", 
  "label" => "<left>|<f1> 2|<right>" )

graph.add_edge( {node1 => :left}, node2 )
graph.add_edge( {node2 => :right}, node1 )

puts graph.output( :none => String, :png => "#{$0}.png" )
