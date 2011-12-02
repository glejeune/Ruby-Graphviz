$:.unshift( "../lib" )
require 'graphviz/dsl'

digraph :G do
   cluster_0 do
      graph[:style => :filled, :color => :lightgrey]
      node[:style => :filled, :color => :white]
      a0 << a1 << a2 << a3
      graph[:label => "process #1"]
   end

   cluster_1 do
      node[:style => :filled]
      b0 << b1 << b2 << b3
      graph[:label => "process #2", :color => :blue]
   end

   start << cluster_0.a0
   start << cluster_1.b0
   cluster_0.a1 << cluster_1.b3
   cluster_1.b2 << cluster_0.a3
   cluster_0.a3 << cluster_0.a0
   cluster_0.a3 << _end
   cluster_1.b3 << _end

   start[:shape] = :Mdiamond
   _end[:label] = "end"
   _end[:shape] = :Mdiamond

   output(:png => "#{$0}.png")
end

