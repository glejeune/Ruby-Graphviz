$:.unshift( "../lib" )
require 'graphviz'

puts GraphViz.graph( :G ) { |g|
  g[:label] = '<<b>This is a test</b>>'
  n1 = g.add_node( "N1", :label => '<<b>node 1</b>>')
  n2 = g.add_node( "N2", :label => '<<b>node 2</b>>')
  g.add_edge( n1, n2, :label => '<<u>edge</u>>')
}.output( :png => "#{$0}.png", :none => String )