$:.unshift( "../../lib" )
require 'graphviz'
require 'graphviz/theory'

require 'pp'

g = GraphViz.digraph( "G", :path => "/usr/local/bin" ) do |g|
  g.a # 1
  g.b # 2
  g.c # 3
  g.d # 4
  g.e # 5
  g.f # 6
  
  g.a << g.a
  g.a << g.b
  g.a << g.d
  (g.a << g.f)[:weight => 6, :label => "6"]
  g.b << g.c
  g.b << g.d
  g.b << g.e
  g.c << g.d
  (g.c << g.f)[:weight => 2, :label => "2"]
  g.d << g.e
end
g.output( :png => "matrix.png" )

t = GraphViz::Theory.new( g )

puts "Matrice d'adjacence : "
puts t.adjancy_matrix

puts "Graph symétrique = #{t.symmetric?}"

puts "Matrice d'incidence : "
puts t.incidence_matrix

g.each_node do |name, node|
  puts "Degré de `#{name}' = #{t.degree(node)}"
end

puts "Matrice des degrés : "
puts t.degree_matrix

puts "Matrice Laplacienne "
puts t.laplacian_matrix

puts "Dijkstra between a and f"
r = t.moore_dijkstra(g.a, g.f)
if r.nil?
  puts "No way !"
else
  print "Path : "; p r[:path]
  print "Distance : #{r[:distance]}"
end

#m = GraphViz::Math::Matrix.new( 4, 5 )
#puts m