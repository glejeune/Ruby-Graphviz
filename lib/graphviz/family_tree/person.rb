require 'rubygems'
require 'graphviz'

class GraphViz
  class FamilyTree
    class Person
      def initialize( graph, cluster, tree, name ) #:nodoc:
        @graph = graph
        @cluster = cluster
        @node = @cluster.add_node( name )
        @node["shape"] = "box"
        @tree = tree
      end
      
      def couples #:nodoc:
        @couples
      end
      
      def node #:nodoc:
        @node
      end
      
      # Define the current person as a man
      #
      #  greg.is_a_man( "Greg" )
      def is_a_man( name )
        @node["label"] = name
        @node["color"] = "blue"
      end
      # Define the current person as a boy
      #
      #  greg.is_a_boy( "Greg" )
      def is_a_boy( name )
        is_a_man( name )
      end
      
      # Define the current perdon as a woman
      #
      #  mu.is_a_woman( "Muriel" )
      def is_a_woman( name )
        @node["label"] = name
        @node["color"] = "pink"
      end
      # Define the current perdon as a girl
      #
      #  maia.is_a_girl( "Maia" )
      def is_a_girl( name )
        is_a_woman( name )
      end
      
      # Define that's two persons are maried
      #
      #  mu.is_maried_with greg
      def is_maried_with( x )
        node = @cluster.add_node( "#{@node.name}And#{x.node.name}" )
        node["shape"] = "point"
        @cluster.add_edge( @node, node, "dir" => "none" )
        @cluster.add_edge( node, x.node, "dir" => "none" )
        @tree.add_couple( self, x, node )
      end
      
      # Define that's two persons are divorced
      #
      #  sophie.is_divorced_with john
      def is_divorced_with( x )
        node = @cluster.add_node( "#{@node.name}And#{x.node.name}" )
        node["shape"] = "point"
        node["color"] = "red"
        @cluster.add_edge( @node, node, "dir" => "none", "color" => "red" )
        @cluster.add_edge( node, x.node, "dir" => "none", "color" => "red" )
        @tree.add_couple( self, x, node )
      end
      
      # Define that's a person is widower of another
      #
      #  simon.is_widower_of elisa
      def is_widower_of( x ) #veuf
        node = @cluster.add_node( "#{@node.name}And#{x.node.name}" )
        node["shape"] = "point"
        node["color"] = "green"
        @cluster.add_edge( @node, node, "dir" => "none", "color" => "green" )
        @cluster.add_edge( node, x.node, "dir" => "none", "color" => "green" )
        @tree.add_couple( self, x, node )
      end

      # Define the kids of a single person
      #
      #   alice.kids( john, jack, julie )
      def kids( *z )
        GraphViz::FamilyTree::Couple.new( @graph, @node ).kids( *z )
      end
    end
  end
end
