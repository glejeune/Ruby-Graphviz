require 'rubygems'
require 'graphviz'

class GraphViz
  class FamilyTree
    class Person
      def initialize( graph, cluster, tree, name )
        @graph = graph
        @cluster = cluster
        @node = @cluster.add_node( name )
        @node["shape"] = "box"
        @tree = tree
      end
      
      def couples
        @couples
      end
      
      def node
        @node
      end
      
      def is_a_man( name )
        @node["label"] = name
        @node["color"] = "blue"
      end
      def is_a_boy( name )
        is_a_man( name )
      end
      
      def is_a_woman( name )
        @node["label"] = name
        @node["color"] = "pink"
      end
      def is_a_girl( name )
        is_a_woman( name )
      end
      
      def is_maried_with( x )
        node = @cluster.add_node( "#{@node.name}And#{x.node.name}" )
        node["shape"] = "point"
        @cluster.add_edge( @node, node, "dir" => "none" )
        @cluster.add_edge( node, x.node, "dir" => "none" )
        @tree.add_couple( self, x, node )
      end
      
      def is_divorced_with( x )
        node = @cluster.add_node( "#{@node.name}And#{x.node.name}" )
        node["shape"] = "point"
        node["color"] = "red"
        @cluster.add_edge( @node, node, "dir" => "none", "color" => "red" )
        @cluster.add_edge( node, x.node, "dir" => "none", "color" => "red" )
        @tree.add_couple( self, x, node )
      end
      
      def is_widower_of( x ) #veuf
        node = @cluster.add_node( "#{@node.name}And#{x.node.name}" )
        node["shape"] = "point"
        node["color"] = "green"
        @cluster.add_edge( @node, node, "dir" => "none", "color" => "green" )
        @cluster.add_edge( node, x.node, "dir" => "none", "color" => "green" )
        @tree.add_couple( self, x, node )
      end

      def kids( *z )
        GraphViz::FamilyTree::Couple.new( @graph, @node ).kids( *z )
      end
    end
  end
end
