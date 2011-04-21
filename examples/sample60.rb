#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

asm = GraphViz::new( "My ASM" ) 

my = asm.add_node("My")
asmn = asm.add_node("ASM")
asm.add_edge(my, asmn) 

asm.output( :png => "#{$0}.png" )
