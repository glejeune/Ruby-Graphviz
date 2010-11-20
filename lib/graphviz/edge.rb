# Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2010 Gregoire Lejeune <gregoire.lejeune@free.fr>
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

require 'graphviz/attrs'
require 'graphviz/constants'

class GraphViz
  class Edge
    include Constants
    @xNodeOne
    @xNodeOnePort
    @xNodeTwo
    @xNodeTwoPort
    @oAttrEdge
    @oGParrent

    # 
    # Create a new edge
    # 
    # In:
    # * vNodeOne : First node (can be a GraphViz::Node or a node ID)
    # * vNodeTwo : Second node (can be a GraphViz::Node or a node ID)
    # * oGParrent : Graph 
    #
    def initialize( vNodeOne, vNodeTwo, oGParrent )
      @xNodeOne, @xNodeOnePort = getNodeNameAndPort( vNodeOne )
	    # if vNodeOne.class == String
      #   @xNodeOne = vNodeOne
	    # else
      #   @xNodeOne = vNodeOne.id
	    # end
	    @xNodeTwo, @xNodeTwoPort = getNodeNameAndPort( vNodeTwo )
	    # if vNodeTwo.class == String
      #   @xNodeTwo = vNodeTwo
	    # else
      #   @xNodeTwo = vNodeTwo.id
	    # end
	    
	    @oGParrent = oGParrent

      @oAttrEdge = GraphViz::Attrs::new( nil, "edge", EDGESATTRS )
      
      @index = nil
    end

    # Return the node one as string (so with port if any)
    def node_one( with_port = true )
      if @xNodeOnePort.nil? or with_port == false
	      GraphViz.escape(@xNodeOne)
      else
        GraphViz.escape(@xNodeOne, :force => true) + ":#{@xNodeOnePort}"
      end
    end
    alias :tail_node :node_one
    
    # Return the node two as string (so with port if any)
    def node_two( with_port = true )
      if @xNodeTwoPort.nil? or with_port == false
	      GraphViz.escape(@xNodeTwo) 
	    else 
	      GraphViz.escape(@xNodeTwo, :force => true) + ":#{@xNodeTwoPort}"
      end
    end
    alias :head_node :node_two
    #
	  # Return the index of the edge
	  #
	  def index
	    @index
    end
    def index=(i) #:nodoc:
      @index = i if @index == nil
    end
    
    # 
    # Set value +xAttrValue+ to the edge attribut +xAttrName+
    # 
	  def []=( xAttrName, xAttrValue )
      xAttrValue = xAttrValue.to_s if xAttrValue.class == Symbol
      @oAttrEdge[xAttrName.to_s] = xAttrValue
    end

    # 
    # Set values for edge attributs or 
    # get the value of the given edge attribut +xAttrName+
    # 
    def []( xAttrName )
      # Modification by axgle (http://github.com/axgle)
      if Hash === xAttrName
        xAttrName.each do |key, value|
          self[key] = value
        end
      else
        if @oAttrEdge[xAttrName.to_s]
          @oAttrEdge[xAttrName.to_s].clone 
        else
          nil
        end
      end
    end
    
    #
    # Calls block once for each attribut of the edge, passing the name and value to the 
    # block as a two-element array.
    #
    # If global is set to false, the block does not receive the attributs set globally
    #
    def each_attribut(global = true, &b)
      attrs = @oAttrEdge.to_h
      if global
        attrs = pg.edge.to_h.merge attrs
      end
      attrs.each do |k,v|
        yield(k,v)
      end
    end
    
    def <<( oNode ) #:nodoc:
      n = @oGParrent.get_node(@xNodeTwo)
      
      GraphViz::commonGraph( oNode, n ).add_edge( n, oNode )
    end
    alias :> :<< #:nodoc:
    alias :- :<< #:nodoc:
    alias :>> :<< #:nodoc:
    
    #
    # Return the root graph
    #
    def root_graph
      return( (self.pg.nil?) ? nil : self.pg.root_graph )
    end
    
    def pg #:nodoc:
      @oGParrent
    end
    
    #
    # Set edge attributs
    #
    # Example :
    #   e = graph.add_edge( ... )
    #   ...
    #   e.set { |_e|
    #     _e.color = "blue"
    #     _e.fontcolor = "red"
    #   }
    # 
    def set( &b )
      yield( self )
    end
    
    # Add edge options
    # use edge.<option>=<value> or edge.<option>( <value> )
    def method_missing( idName, *args, &block ) #:nodoc:
      return if idName == :to_ary # ruby 1.9.2 fix
      xName = idName.id2name
      
      self[xName.gsub( /=$/, "" )]=args[0]
    end
    
	  def output( oGraphType ) #:nodoc:
	    xLink = " -> "
	    if oGraphType == "graph"
	      xLink = " -- "
	    end
	  
      xOut = self.node_one + xLink + self.node_two
      xAttr = ""
      xSeparator = ""
      @oAttrEdge.data.each do |k, v|
        xAttr << xSeparator + k + " = " + v.to_gv
        xSeparator = ", "
      end
      if xAttr.length > 0
        xOut << " [" + xAttr + "]"
      end
      xOut + ";"

      return( xOut )
	  end
  
    private
    def getNodeNameAndPort( node )
      name, port = nil, nil
      if node.class == Hash
        node.each do |k, v|
          name, port = getNodeNameAndPort(k)
          port = v
        end
	    elsif node.class == String
        name = node
	    else
        name = node.id
      end
      
      return name, port
    end
  end
end
