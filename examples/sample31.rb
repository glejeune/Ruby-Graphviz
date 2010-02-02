#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

puts GraphViz.new(:g){ |g|
  a = g.add_node( "A:B:C", :shape => :record )
  b = g.add_node( "D:E:F", :shape => :ellipse )
  a << b 
}.save( :canon => String )