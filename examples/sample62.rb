#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

asm = GraphViz::new( "" ) 

my = asm.add_node("Hello")
asmn = asm.add_node("World")
asm.add_edge(my, asmn) 

final_graph = GraphViz.parse_string( asm.output( :dot => String ) )
final_graph.each_node do |_, node|
   puts "Node #{node.id} : position = #{node[:pos]}"
end
