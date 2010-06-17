# This file use notugly.xsl: An XSL transform to pretty up the SVG output from Graphviz
# 
# See: http://www.hokstad.com/making-graphviz-output-pretty-with-xsl.html
# And: http://www.hokstad.com/making-graphviz-output-pretty-with-xsl-updated.html
# 
# By Vidar Hokstad and Ryan Shea; Contributions by Jonas Tingborn,
# Earl Cummings, Michael Kennedy (Graphviz 2.20.2 compatibility, bug fixes,
# testing, lots of gradients)

require 'rubygems'
require 'xml/xslt'

class GraphViz
  # Transform to pretty up the SVG output
  #
  # For more information, see http://www.hokstad.com/making-graphviz-output-pretty-with-xsl.html
  # and http://www.hokstad.com/making-graphviz-output-pretty-with-xsl-updated.html
  #
  # You can use the :nothugly option to GraphViz#output :
  #
  #   graph.output( :svg => "myGraph.svg", :nothugly => true )
  #
  # Or directly on an SVG output graph :
  #
  #   GraphViz.nothugly( "myGraph.svg" )
  def self.nothugly( file, save = true )
    xslt = XML::XSLT.new()
    xslt.xml = file
    xslt.xsl = File.join( File.dirname(File.expand_path(__FILE__)), "nothugly", "nothugly.xsl" )

    out = xslt.serve()
  
    if save
      fname = File.join( File.dirname(File.expand_path(file)), File.basename(file))
      File.open( fname, "w" ) { |io|
        io.print out
      }
    else
      return out
    end
  end
end