#!/usr/bin/ruby

$:.unshift( "../lib" )
require 'graphviz/xml'

gvxml = GraphViz::XML::new( "test.xml", :text => true, :attrs => true )
gvxml.output( :png => "#{$0}.png", :use => "dot" )
