#!/usr/bin/env ruby
# Copyright (C) 2010 Gregoire Lejeune <gregoire.lejeune@free.fr>
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

require 'graphviz'
require 'rexml/document'

class GraphViz
  class GraphML
    attr_reader :attributs
    attr_accessor :graph
  
    DEST = {
      'node'  => [:nodes],
      'edge'  => [:edges],
      'graph' => [:graphs],
      'all'   => [:nodes, :edges, :graphs]
    }
    
    GTYPE = {
      'directed' => :digraph,
      'undirected' => :graph
    }
    
    def initialize( file_or_str )
      data = ((File.file?( file_or_str )) ? File::new(file_or_str) : file_or_str) 
      @xmlDoc = REXML::Document::new( data )
      @attributs = {
        :nodes => {},
        :edges => {},
        :graphs => {}
      }
      @graph = nil
      @current_attr = nil
      @current_node = nil
      @current_edge = nil
      @current_graph = nil
      
      parse( @xmlDoc.root )
    end
    
    def parse( node )
      #begin
        send( node.name.to_sym, node )
      #rescue NoMethodError => e
      #  raise "ERROR node #{node.name} can be root"
      #end
    end
    
    def graphml( node )
      node.each_element( ) do |child|
        #begin
          send( "graphml_#{child.name}".to_sym, child )
        #rescue NoMethodError => e
        #  raise "ERROR node #{child.name} can be child of graphml"
        #end
      end
    end
    
    def graphml_key( node )
      id = node.attributes['id']
      @current_attr = {
        :name => node.attributes['attr.name'],
        :type => node.attributes['attr.type']
      }    
      DEST[node.attributes['for']].each do |d|
        @attributs[d][id] = @current_attr
      end
      
      node.each_element( ) do |child|
        begin
          send( "graphml_key_#{child.name}".to_sym, child )
        rescue NoMethodError => e
          raise "ERROR node #{child.name} can be child of graphml"
        end
      end
      
      @current_attr = nil
    end
    
    def graphml_key_default( node )
      @current_attr[:default] = node.texts().to_s
    end
    
    def graphml_graph( node )
      @current_node = nil
      
      if @current_graph.nil?
        @graph = GraphViz.new( node.attributes['id'], :type => GTYPE[node.attributes['edgedefault']] )
        @current_graph = @graph
        previous_graph = @graph
      else
        previous_graph = @current_graph      
        @current_graph = previous_graph.add_graph( node.attributes['id'] )
      end
      
      @attributs[:graphs].each do |id, data|
        @current_graph.graph[data[:name]] = data[:default] if data.has_key?(:default)
      end
      @attributs[:nodes].each do |id, data|
        @current_graph.node[data[:name]] = data[:default] if data.has_key?(:default)
      end
      @attributs[:edges].each do |id, data|
        @current_graph.edge[data[:name]] = data[:default] if data.has_key?(:default)
      end
          
      node.each_element( ) do |child|
        #begin
          send( "graphml_graph_#{child.name}".to_sym, child )
        #rescue NoMethodError => e
        #  raise "ERROR node #{child.name} can be child of graphml"
        #end
      end
      
      @current_graph = previous_graph
    end
    
    def graphml_graph_data( node )
      @current_graph[@attributs[:graphs][node.attributes['key']][:name]] = node.texts().to_s
    end
    
    def graphml_graph_node( node )
      @current_node = {}
  
      node.each_element( ) do |child|
        case child.name
        when "graph"
          graphml_graph( child )
        else
          begin
            send( "graphml_graph_node_#{child.name}".to_sym, child )
          rescue NoMethodError => e
            raise "ERROR node #{child.name} can be child of graphml"
          end
        end
      end
      
      unless @current_node.nil?
        node = @current_graph.add_node( node.attributes['id'] )
        @current_node.each do |k, v|
          node[k] = v
        end
      end
      
      @current_node = nil
    end
    
    def graphml_graph_node_data( node )
      @current_node[@attributs[:nodes][node.attributes['key']][:name]] = node.texts().to_s
    end
    
    def graphml_graph_node_port( node )
      @current_node[:shape] = :record
      port = node.attributes['name']
      if @current_node[:label]
        label = @current_node[:label].gsub( "{", "" ).gsub( "}", "" )
        @current_node[:label] = "#{label}|<#{port}> #{port}"
      else
        @current_node[:label] = "<#{port}> #{port}"
      end
    end
    
    def graphml_graph_edge( node )
      source = node.attributes['source']
      source = {source => node.attributes['sourceport']} if node.attributes['sourceport']
      target = node.attributes['target']
      target = {target => node.attributes['targetport']} if node.attributes['targetport']
      
      @current_edge = @current_graph.add_edge( source, target )
  
      node.each_element( ) do |child|
        #begin
          send( "graphml_graph_edge_#{child.name}".to_sym, child )
        #rescue NoMethodError => e
        #  raise "ERROR node #{child.name} can be child of graphml"
        #end
      end
      
      @current_edge = nil
    end
  
    def graphml_graph_edge_data( node )
      @current_edge[@attributs[:edges][node.attributes['key']][:name]] = node.texts().to_s
    end
    
    def graphml_graph_hyperedge( node )
      list = []
      
      node.each_element( ) do |child|
        if child.name == "endpoint"
          if child.attributes['port']
            list << { child.attributes['node'] => child.attributes['port'] }
          else
            list << child.attributes['node']
          end
        end
      end
      
      list.each { |s|
        list.each { |t|
          @current_graph.add_edge( s, t ) unless s == t
        }
      } 
    end
  end
end