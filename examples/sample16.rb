#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

GraphViz::new( "G", :type => "graph", :output => "png", :rankdir => "LR" ) { |graph|
  graph.add_edge( [graph.a, graph.b, graph.c], [ graph.d, graph.e, graph.f ] )
}.output( :path => '/usr/local/bin/', :file => "#{$0}.png" )