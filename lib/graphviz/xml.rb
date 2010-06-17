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

require 'graphviz'
require 'rexml/document'

class GraphViz
  class XML
    
    @oReXML
    @oGraph 
    @xNodeName
	  @bShowText
	  @bShowAttrs
    
    # 
    # Generate the graph
    # 
    # Options :
    # * :output : Output format (Constants::FORMATS)
    # * :file : Output file name
    # * :use : Program to use (Constants::PROGRAMS)
    # * :path : Program PATH
    # * :<format> => <file> : <file> can be
    #   * a file name
    #   * nil, then the output will be printed to STDOUT
    #   * String, then the output will be returned as a String
    # * :errors : DOT error level (default 1)
    #   * 0 = Error + Warning
    #   * 1 = Error
    #   * 2 = none
    # 
    def output( *hOpt )
      @oGraph.output( *hOpt )
    end
    
    private
    
    # 
    # Create a graph from a XML file
    # 
    # In:
    # * xFile : XML File
    # * *hOpt : Graph options
    # 
    def initialize( xFile, *hOpt )
      @xNodeName = "00000"
	    @bShowText = true
	    @bShowAttrs = true

      if hOpt.nil? == false and hOpt[0].nil? == false
        hOpt[0].each do |xKey, xValue|
          case xKey.to_s
            when "text"
              @bShowText = xValue
		          hOpt[0].delete( xKey )
            when "attrs"
              @bShowAttrs = xValue
		          hOpt[0].delete( xKey )
          end
        end
      end

      @oReXML = REXML::Document::new( File::new( xFile ) )
      @oGraph = GraphViz::new( "XML", *hOpt ) 
      _init( @oReXML.root() )
    end
    
    def _init( oXMLNode ) #:nodoc:
      xLocalNodeName = @xNodeName.clone
      @xNodeName.succ!
      
      label = oXMLNode.name
      if oXMLNode.has_attributes? == true and @bShowAttrs == true
        label = "{ " + oXMLNode.name 
		
		    oXMLNode.attributes.each do |xName, xValue|
		      label << "| { #{xName} | #{xValue} } " 
		    end
		
		    label << "}"
	    end
      @oGraph.add_node( xLocalNodeName, "label" => label, "color" => "blue", "shape" => "record" )

      ## Act: Search and add Text nodes
      if oXMLNode.has_text? == true and @bShowText == true
        xTextNodeName = xLocalNodeName.clone
        xTextNodeName << "111"
        
        xText = ""
        xSep = ""
        oXMLNode.texts().each do |l|
          x = l.value.chomp.strip
          if x.length > 0
            xText << xSep << x
            xSep = "\n"
          end
        end

        if xText.length > 0
          @oGraph.add_node( xTextNodeName, "label" => xText, "color" => "black", "shape" => "ellipse" )
          @oGraph.add_edge( xLocalNodeName, xTextNodeName )
        end
      end

      ## Act: Search and add attributs
      ## TODO

      oXMLNode.each_element( ) do |oXMLChild|
        xChildNodeName = _init( oXMLChild )
        @oGraph.add_edge( xLocalNodeName, xChildNodeName )
      end

      return( xLocalNodeName )
    end

  end
end
