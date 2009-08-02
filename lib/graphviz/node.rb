# Copyright (C) 2004, 2005, 2006, 2007, 2008 Gregoire Lejeune <gregoire.lejeune@free.fr>
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
    #   xNodeName : Name of the node
    #   oGParrent : Graph 
    # 
    def initialize( xNodeName, oGParrent = nil )
      @xNodeName = xNodeName
      @oGParrent = oGParrent
      @oAttrNode = GraphViz::Attrs::new( nil, "node", NODESATTRS )
    end

    # 
    # Get the node name
    # 
    def name
	    @xNodeName.clone
	  end
	
	  # 
    # Set value +xAttrValue+ to the node attribut +xAttrName+
    # 
    def []=( xAttrName, xAttrValue )
      @oAttrNode[xAttrName.to_s] = xAttrValue
    end

    # 
    # Get the value of the node attribut +xAttrName+
    # 
    def []( xAttrName )
      @oAttrNode[xAttrName.to_s].clone
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
      xOut = "" << @xNodeName.clone
      xAttr = ""
      xSeparator = ""
      @oAttrNode.data.each do |k, v|
	      if k == "html"
		      xAttr << xSeparator + "label = <" + v + ">"
		    else
          xAttr << xSeparator + k + " = \"" + v + "\""
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
