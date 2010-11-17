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
  class Node
    include Constants
    @xNodeName
    @oAttrNode
    @oGParrent
    
    # 
    # Create a new node
    # 
    # In:
    # * xNodeName : ID of the node
    # * oGParrent : Graph 
    # 
    def initialize( xNodeName, oGParrent )
      @xNodeName = xNodeName
      @oGParrent = oGParrent
      @oAttrNode = GraphViz::Attrs::new( nil, "node", NODESATTRS )
      @index = nil
    end

    # 
    # Get the node ID
    # 
    def name
	    warn "GraphViz::Node#name is deprecated, please use GraphViz::Node#id!"
	    return self.id
	  end

    # 
    # Get the node ID
    # 
    def id
	    @xNodeName.clone
	  end
	  
	  #
	  # Return the node index
	  #
	  def index
	    @index
    end
    def index=(i) #:nodoc:
      @index = i if @index == nil
    end

    #
    # Return the root graph
    #
    def root_graph
      return( (self.pg.nil?) ? nil : self.pg.root_graph )
    end
    
	  # 
    # Set value +xAttrValue+ to the node attribut +xAttrName+
    # 
    def []=( xAttrName, xAttrValue )
      xAttrValue = xAttrValue.to_s if xAttrValue.class == Symbol
      @oAttrNode[xAttrName.to_s] = xAttrValue
    end

    # 
    # Get the value of the node attribut +xAttrName+
    # 
    def []( xAttrName )
      if Hash === xAttrName
        xAttrName.each do |key, value|
          self[key] = value
        end
      else
        (@oAttrNode[xAttrName.to_s].nil?)?nil:@oAttrNode[xAttrName.to_s].clone
      end
    end

    #
    # Calls block once for each attribut of the node, passing the name and value to the 
    # block as a two-element array.
    #
    # If global is set to false, the block does not receive the attributs set globally
    #
    def each_attribut(global = true, &b)
      attrs = @oAttrNode.to_h
      if global
        attrs = pg.node.to_h.merge attrs
      end
      attrs.each do |k,v|
        yield(k,v)
      end
    end
    
    # 
    # Create an edge between the current node and the node +oNode+
    # 
    def <<( oNode )
      if( oNode.class == Array ) 
        oNode.each do |no|
          self << no
        end
      else
        return GraphViz::commonGraph( oNode, self ).add_edge( self, oNode )
      end
    end
    alias :> :<<
    alias :- :<<
    alias :>> :<<
    
    #
    # Set node attributs
    #
    # Example :
    #   n = graph.add_node( ... )
    #   ...
    #   n.set { |_n|
    #     _n.color = "blue"
    #     _n.fontcolor = "red"
    #   }
    # 
    def set( &b )
      yield( self )
    end
    
    # Add node options
    # use node.<option>=<value> or node.<option>( <value> )
    def method_missing( idName, *args, &block ) #:nodoc:
      xName = idName.id2name
      
      self[xName.gsub( /=$/, "" )]=args[0]
    end
    
    def pg #:nodoc:
      @oGParrent
    end
    
    def output #:nodoc:
      #xNodeName = @xNodeName.clone
      #xNodeName = '"' << xNodeName << '"' if xNodeName.match( /^[a-zA-Z_]+[a-zA-Z0-9_\.]*$/ ).nil?
      xNodeName = GraphViz.escape(@xNodeName)
      
      xOut = "" << xNodeName
      xAttr = ""
      xSeparator = ""
      
      if @oAttrNode.data.has_key?("label") and @oAttrNode.data.has_key?("html")
        @oAttrNode.data.delete("label")
      end
      @oAttrNode.data.each do |k, v|
	      if k == "html"
	        warn "html attribut is deprecated, please use label : :label => '<<html />>'"
		      xAttr << xSeparator + "label = " + v.to_gv
		    else
          xAttr << xSeparator + k + " = " + v.to_gv
		    end
        xSeparator = ", "
      end
      if xAttr.length > 0
        xOut << " [" + xAttr + "]"
      end
      xOut << ";"

      return( xOut )
    end
  end
end
