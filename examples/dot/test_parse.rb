#!/usr/bin/ruby

$:.unshift( "../../lib" );
require "graphviz"

Dir.glob( "*.dot" ) { |f|
  print "#{f} : "
  begin
    puts GraphViz.parse(f)
  rescue SyntaxError => e
    puts "Error #{e.message}"
  end
}
