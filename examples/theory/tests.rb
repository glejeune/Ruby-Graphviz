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

puts "Adjancy matrix : "
puts t.adjancy_matrix
# => [ 1 1 0 1 0 1]
#    [ 0 0 1 1 1 0]
#    [ 0 0 0 1 0 1]
#    [ 0 0 0 0 1 0]
#    [ 0 0 0 0 0 0]
#    [ 0 0 0 0 0 0]

puts "Symmetric ? #{t.symmetric?}"

puts "Incidence matrix :"
puts t.incidence_matrix
# => [  2  1  1  1  0  0  0  0  0  0]
#    [  0 -1  0  0  1  1  1  0  0  0]
#    [  0  0  0  0 -1  0  0  1  1  0]
#    [  0  0 -1  0  0 -1  0 -1  0  1]
#    [  0  0  0  0  0  0 -1  0  0 -1]
#    [  0  0  0 -1  0  0  0  0 -1  0]

g.each_node do |name, node|
  puts "Degree of node `#{name}' = #{t.degree(node)}"
end

puts "Degree matrix : "
puts t.degree_matrix
# => [ 4 0 0 0 0 0]
#    [ 0 4 0 0 0 0]
#    [ 0 0 3 0 0 0]
#    [ 0 0 0 4 0 0]
#    [ 0 0 0 0 2 0]
#    [ 0 0 0 0 0 2]


puts "Laplacian matrix :"
puts t.laplacian_matrix
# => [  3 -1  0 -1  0 -1]
#    [  0  4 -1 -1 -1  0]
#    [  0  0  3 -1  0 -1]
#    [  0  0  0  4 -1  0]
#    [  0  0  0  0  2  0]
#    [  0  0  0  0  0  2]

puts "Dijkstra between a and f"
r = t.moore_dijkstra(g.a, g.f)
if r.nil?
  puts "No way !"
else
  print "Path : "; p r[:path]
  print "Distance : #{r[:distance]}"
end
# => Path : ["a", "b", "c", "f"]
#    Distance : 4.0
