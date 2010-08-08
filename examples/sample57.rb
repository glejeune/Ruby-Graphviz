$:.unshift( "../lib" )

require 'graphviz/graphml'

g = GraphViz::GraphML.new( "graphml/cluster.graphml" )
g.graph.output( :path => "/usr/local/bin", :png => "#{$0}.png" )
