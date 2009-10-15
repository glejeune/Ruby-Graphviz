#!/usr/bin/ruby

$:.unshift( "../../lib" );
require "graphviz"

GraphViz.parse( "hello.dot", :path => "/usr/local/bin" ) { |g|
  g.get_node("Hello") { |n|
    n.label = "Bonjour"
  }
  g.get_node("World") { |n|
    n.label = "Le Monde"
  }
}.output(:png => "sample.png")

