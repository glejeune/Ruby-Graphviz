require 'rubygems'
require 'graphviz'
require 'graphviz/family_tree/generation'
require 'graphviz/family_tree/person'
require 'graphviz/family_tree/couple'

class GraphViz
  class FamilyTree
    def initialize( &block )
      @persons = {}
      @graph = GraphViz.new( "FamilyTree" )
      @generation = 0
      @couples = {}
      
      instance_eval(&block) if block
    end
    
    def generation( &b )
      GraphViz::FamilyTree::Generation.new( @graph, @persons, self, @generation ).make( &b )
      @generation += 1
    end
    
    def persons
      @persons ||= {}
    end
    
    def add_couple( x, y, node )
      @couples[x] = {} if @couples[x].nil?
      @couples[x][y] = GraphViz::FamilyTree::Couple.new( @graph, node )
      @couples[y] = {} if @couples[y].nil?
      @couples[y][x] = @couples[x][y]
    end
    
    def couple( x, y )
      @couples[x][y]
    end
    
    def method_missing(sym, *args, &block)
      persons[sym.to_s]
    end
    
    def graph
      @graph
    end
  end
end
