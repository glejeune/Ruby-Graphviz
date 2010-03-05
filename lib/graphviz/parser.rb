# Copyright (C) 2009 Gregoire Lejeune <gregoire.lejeune@free.fr>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
require 'rubygems'
require 'treetop'

Treetop.load File.dirname(__FILE__) + '/dot.treetop'

class GraphViz
  class Parser

    class Context
      def initialize
        @graph = nil
        @nodes = {}
        @edges = []
        @options = {
          :node => {},
          :edge => {}
        }
      end
      
      def graph
        @graph
      end
      
      def graph=(g)
        @graph = g
      end
      
      def nodes
        @nodes
      end
      
      def edges
        @edges
      end
      
      def options
        @options
      end
      
      def options=(o)
        @options = o
      end
    end
    
    class Graph < Treetop::Runtime::SyntaxNode
      def eval( context, hOpts = [] )
        # puts "GRAPH TYPE = #{type.text_value}"
        # puts "GRAPH NAME = #{name.text_value}"
        
        begin
          hOpts = hOpts[0].merge( {:type => type.text_value} )
        rescue
          hOpts = {:type => type.text_value}
        end
        
        # Create Graph
        context.graph = GraphViz.new( name.text_value.gsub(/"/, ""), hOpts )
        
        # Eval cluster
        cluster.eval( context )
        
        return context.graph
      end
    end
    
    class Cluster < Treetop::Runtime::SyntaxNode
      def eval( context )
        content.elements.each do |e|
          e.eval( context )
        end
      end
    end
    
    class GraphPreference < Treetop::Runtime::SyntaxNode
      def eval( context )
        # puts "GRAPH PREFERENCE : "
        # puts "  #{key.text_value} = #{value.text_value.gsub(/"/, "")}"
        context.graph[key.text_value] = value.text_value.gsub(/"/, "")
      end
    end
    
    class NamedGraphPreference < Treetop::Runtime::SyntaxNode
      def eval( context )
        # puts "GRAPH PREFERENCES :"
        options.eval().each do |k,v|
          context.graph[k] = v
        end
      end
    end
    
    class NodePreference < Treetop::Runtime::SyntaxNode
      def eval( context )
        # puts "NODE PREFERENCES :"
        context.options[:node] = context.options[:node].merge( options.eval() )
      end
    end
    
    class EdgePreference < Treetop::Runtime::SyntaxNode
      def eval( context )
        # puts "EDGE PREFERENCES :"
        context.options[:edge] = context.options[:edge].merge( options.eval() )
      end
    end
    
    class Node < Treetop::Runtime::SyntaxNode
      def eval( context )
        node_name = name.text_value.gsub( /"/, "" )
        # puts "NODE NAME = #{node_name}"
        # puts "OPTIONS = "
        
        # Create node
        node = context.nodes[node_name] || context.graph.add_node( node_name )
    
        # Add global options
        context.options[:node].each do |k, v|
          node[k] = v
        end
        
        # Add custom options
        unless options.terminal?
          options.eval().each do |k, v|
            node[k] = v
          end
        end
        
        # Save node
        context.nodes[node_name] = node
      end
    end
    
    class Edge < Treetop::Runtime::SyntaxNode
      def create_node( name, context )
        # puts "  NEED TO CREATE NODE : #{name}"
        # Create the node
        node = context.graph.add_node( name )
        
        # Add global options
        context.options[:node].each do |k, v|
          node[k] = v
        end
        
        # Save node
        context.nodes[name] = node
      end
      
      def create_edge( one, two, edge_options, context )
        # Create edge
        edge = context.graph.add_edge( one, two )
        
        # Add global options
        context.options[:edge].each do |k, v|
          edge[k] = v
        end
        
        # Add custom options
        edge_options.each do |k, v|
          edge[k] = v
        end
        
        # Save edge
        context.edges << edge
      end
      
      def eval( context )
        one_name = node_one.text_value.gsub( /"/, "" )
        two_name = node_two.text_value.gsub( /"/, "" )
        # puts "EDGE"
        # puts "NODE ONE = #{one_name}"
        # puts "NODE TWO = #{two_name}"
        # puts "OPTIONS = "
        
        # Get or create node one
        one = context.nodes[one_name] || create_node( one_name, context )
    
        # Get or create node two
        two = context.nodes[two_name] || create_node( two_name, context )
        
        # Get options 
        edge_options = {}
        edge_options = options.eval() unless options.terminal?
        
        # Create edge
        create_edge( one, two, edge_options, context )
        
        last_node = two
        other_nodes.elements.each do |e|
          new_node_name = e.next_node.text_value.gsub( /"/, "" )
          # puts "OTHER NODE : #{new_node_name}"
          
          new_node = context.nodes[new_node_name] || create_node( new_node_name, context )
          create_edge( last_node, new_node, edge_options, context )
          
          last_node = new_node
        end
      end
    end
    
    class Subgraph < Treetop::Runtime::SyntaxNode
      def eval( context )
        # puts "CREATE SUBGRAPH : #{name.text_value}"
        
        # Save options
        saved_options = context.options.clone
        # Save graph 
        saved_graph = context.graph
        
        # Create Graph
        context.graph = context.graph.add_graph( name.text_value.gsub(/"/, "") )
        #context.options = {
        #  :node => {},
        #  :edge => {}
        #}
        
        # Eval cluster
        cluster.eval( context )
        
        # Reinitialize graph and options
        context.graph = saved_graph
        context.options = saved_options
      end
    end
    
    class Options < Treetop::Runtime::SyntaxNode
      def eval
        options = {}
        elements[2].elements.each do |e|
          # puts "  #{e.elements[0].text_value} = #{e.elements[4].text_value}"
          options[e.elements[0].text_value] = e.elements[4].text_value.gsub( /"/, "" )
        end
        # puts "  #{elements[3].text_value} = #{elements[7].text_value}"
        options[elements[3].text_value] = elements[7].text_value.gsub( /"/, "" )
        
        return options
      end
    end

    def self.parse( file, *hOpts, &block )
      dot = open(file).read
      parser = DotParser.new()
      tree = parser.parse( dot )
      graph = tree.eval( GraphViz::Parser::Context.new(), hOpts )
      
      yield( graph ) if( block and graph.nil? == false )
      
      return graph
    end
  end
end
