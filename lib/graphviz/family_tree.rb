require 'rubygems'
require 'graphviz'
require 'graphviz/family_tree/generation'
require 'graphviz/family_tree/person'
require 'graphviz/family_tree/couple'

class GraphViz
  class FamilyTree
    # Create a new family tree
    #
    #   require 'graphviz/family_tree'
    #   t = GraphViz::FamilyTree.new do
    #     ...
    #   end
    def initialize( &block )
      @persons = {}
      @graph = GraphViz.new( "FamilyTree" )
      @generation = 0
      @couples = {}
      
      instance_eval(&block) if block
    end
    
    # Add a new generation in the tree
    #
    #   require 'graphviz/family_tree'
    #   t = GraphViz::FamilyTree.new do
    #     generation do
    #       ...
    #     end
    #     generation do
    #       ...
    #     end
    #   end
    def generation( &b )
      GraphViz::FamilyTree::Generation.new( @graph, @persons, self, @generation ).make( &b )
      @generation += 1
    end
    
    def persons #:nodoc:
      @persons ||= {}
    end
    
    def add_couple( x, y, node ) #:nodoc:
      @couples[x] = {} if @couples[x].nil?
      @couples[x][y] = GraphViz::FamilyTree::Couple.new( @graph, node )
      @couples[y] = {} if @couples[y].nil?
      @couples[y][x] = @couples[x][y]
    end
    
    # Get a couple (GraphViz::FamilyTree::Couple)
    def couple( x, y ) 
      @couples[x][y]
    end
    
    def method_missing(sym, *args, &block) #:nodoc:
      persons[sym.to_s]
    end
    
    # Get the graph
    def graph
      @graph
    end
  end
end
