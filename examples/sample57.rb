$:.unshift( "../lib" )

require 'graphviz/graphml'

graphml = File.join( File.dirname( File.expand_path( __FILE__ ) ), "graphml", "cluster.graphml" )
g = GraphViz::GraphML.new( graphml )
g.graph.output( :png => "#{$0}.png" )
