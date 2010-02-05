#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

GraphViz.new(:g){ |g|
  a = g.add_node( "A", :label => "A:B:C", :shape => :record )
  b = g.add_node( "B", :label => "D:E:F", :shape => :ellipse )
  a << b 
}.save( :png => "#{$0}.png" )