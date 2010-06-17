#!/usr/bin/ruby

$:.unshift( "../lib" );
require "graphviz"

g = nil
if ARGV[0]
  g = GraphViz::new( "G", "path" => ARGV[0], :use => "circo" )
else
  g = GraphViz::new( "G" )
end

c0 = g.add_graph( "cluster0" )
c0["label"] = "Environnement de Brad !"
c0["style"] = "filled"
c0["color"] = "blue"

ja = c0.add_node( "Jennifer_Aniston", :style => "filled", :color => "red" )
bp = c0.add_node( "Brad_Pitt", :style => "filled", :color => "white" )
aj = c0.add_node( "Angelina_Jolie", :style => "filled", :color => "green" )

c0.add_edge( ja, bp ) # On ete mariés
c0.add_edge( bp, aj ) # Sont ensemble

jv = g.add_node( "John_Voight", :label => "John Voight", :shape => "rectangle" )
md = g.add_node( "Madonna" )
gr = g.add_node( "Guy_Ritchie" )

g.add_edge( aj, jv ) # est la fille de
g.add_edge( jv, aj ) # est le pere de
g.add_edge( bp, jv, :color => "red", :label => "Est le beau fils de" ) # Beau fils
g.add_edge( bp, gr )
g.add_edge( gr, md )

g.output( :png => "#{$0}.png" )