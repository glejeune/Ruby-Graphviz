class GraphViz
  class FamilyTree
    class Generation
      def initialize( graph, persons, tree, gen_number )
        @graph = graph
        @persons = persons
        @cluster = @graph.add_graph( "Generation#{gen_number}" )
        @cluster["rank"] = "same"
        @tree = tree
      end
      
      def persons
        @persons
      end
      
      def make( &block )
        instance_eval(&block) if block
      end
      
      def method_missing(sym, *args, &block)
        persons[sym.to_s] ||= GraphViz::FamilyTree::Person.new( @graph, @cluster, @tree, sym.to_s )
      end
    end
  end
end
