# coding: utf-8
$:.unshift( "../lib" )
require "graphviz"

g = GraphViz::new( :G ) { |g|
  g.a[:label => "ε"]
  g.add_node( "b", :label => "ε" )
  g.c[:label => 'ε']
  g.add_node( "d", :label => 'ε' )
}

puts g.output( :none => String, :png => "#{$0}.png", :path => "/usr/local/bin" )
