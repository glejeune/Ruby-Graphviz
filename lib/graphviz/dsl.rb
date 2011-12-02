require 'graphviz'

class GraphViz::DSL
   attr_accessor :graph

   def initialize(name, hOpts = {}, &block)
      @graph = GraphViz.new(name, hOpts)
      instance_eval(&block) if block
   end

   def method_missing(sym, *args, &block)
      return @graph.get_graph(sym.to_s) unless(@graph.get_graph(sym.to_s).nil?)
      return @graph.get_node(sym.to_s) unless(@graph.get_node(sym.to_s).nil?)
      if(@graph.respond_to?(sym, true))
         @graph.send(sym, *args)
      elsif(block)
         @graph.add_graph(GraphViz::DSL.new(sym, { :parent => @graph, :type => @graph.type }, &block).graph)
      else
         @graph.add_node(sym.to_s, *args)
      end
   end

   def subgraph(name, &block) 
      @graph.add_graph(GraphViz::DSL.new(name, { :parent => @graph, :type => @graph.type }, &block).graph)
   end

   def output(hOpts = {}) 
      @graph.output(hOpts)
   end
end

def graph(name, hOpts = {}, &block) 
   GraphViz::DSL.new(name, hOpts.merge( { :type => "graph" } ), &block).graph
end

def digraph(name, hOpts = {}, &block) 
   GraphViz::DSL.new(name, hOpts.merge( { :type => "digraph" } ), &block).graph
end

def strict(name, hOpts = {}, &block) 
   GraphViz::DSL.new(name, hOpts.merge( { :type => "strict digraph" } ), &block).graph
end

