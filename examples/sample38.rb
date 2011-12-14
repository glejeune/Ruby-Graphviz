# coding: utf-8
$:.unshift( "../lib" )
require "graphviz"

g = GraphViz::new( :G ) { |g|
  g.a[:label => "ε"]
  g.add_nodes( "b", :label => "ε" )
  g.c[:label => 'ε']
  g.add_nodes( "d", :label => 'ε' )
}

puts g.output( :none => String, :png => "#{$0}.png", :path => "/usr/local/bin" )
