# Copyright (C) 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010 Gregoire Lejeune <gregoire.lejeune@free.fr>
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


IS_JRUBY = (defined?( JRUBY_VERSION ) != nil)
IS_CYGWIN = ((RUBY_PLATFORM =~ /cygwin/) != nil)

require 'tempfile'

require 'graphviz/utils'
require 'graphviz/node'
require 'graphviz/edge'
require 'graphviz/attrs'
require 'graphviz/constants'
require 'graphviz/elements'

require 'graphviz/dot2ruby'
require 'graphviz/types'
require 'graphviz/core_ext'

if /^1.8/.match RUBY_VERSION
  $KCODE = "UTF8"
end

class GraphViz 
  include Constants
  include GVUtils

  public

  ## Var: Output format (dot, png, jpeg, ...)
  @@format = nil #"canon"
  @format
  ## Var: Output file name
  @filename
  ## Var: Output format and file
  @output
  ## Var: program to use (dot|twopi)
  @@prog = "dot"
  @prog
  ## Var: program path
  @@path = []
  @path
  ## Var: Error level
  @@errors = 1
  @errors
  ## Var: External libraries
  @@extlibs = []
  @extlibs
  
  ## Var: Graph name
  @name

  ## Var: defined attributs
  @graph
  @node
  @edge

  # This accessor allow you to set global graph attributs
  attr_accessor :graph
  alias_method :graph_attrs, :graph
  
  # This accessor allow you to set global nodes attributs
  attr_accessor :node
  alias_method :node_attrs, :node

  # This accessor allow you to set global edges attributs
  attr_accessor :edge
  alias_method :edge_attrs, :edge

  @elements_order
  
  ##
  # Create a new node
  #
  # In:
  # * xNodeName : Name of the new node
  # * hOpts : Node attributs
  # 
  # Return the GraphViz::Node object created
  #
  def add_node( xNodeName, hOpts = {} )
    @hoNodes[xNodeName] = GraphViz::Node::new( xNodeName, self )
    @hoNodes[xNodeName].index = @elements_order.size_of( "node" )
    
    unless hOpts.keys.include?(:label) or hOpts.keys.include?("label")
      hOpts[:label] = xNodeName
    end
      
    hOpts.each do |xKey, xValue|
      @hoNodes[xNodeName][xKey.to_s] = xValue
    end
    
    @elements_order.push( { 
      "type" => "node", 
      "name" => xNodeName,
      "value" => @hoNodes[xNodeName] 
    } )
    
    return( @hoNodes[xNodeName] )
  end

  #
  # Return the node object for the given name (or nil)
  #
  def get_node( xNodeName, &block )
    node = @hoNodes[xNodeName] || nil
    
    yield( node ) if( block and node.nil? == false )
    
    return node
  end
  
  #
  # Return the node object for the given index
  #
  def get_node_at_index( index )
    element = @elements_order[index, "node"]
    (element.nil?) ? nil : element["value"]
  end
  
  #
  # Allow you to traverse nodes
  #
  def each_node( &block )
    if block_given?
      @hoNodes.each do |name, node|
        yield( name, node )
      end
    else
      return( @hoNodes )
    end
  end
  
  #
  # Get the number of nodes
  #
  def node_count
    @hoNodes.size
  end
  
  ##
  # Create a new edge
  # 
  # In:
  # * oNodeOne : First node (or node list)
  # * oNodeTwo : Second Node (or node list)
  # * hOpts : Edge attributs
  #
  def add_edge( oNodeOne, oNodeTwo, hOpts = {} )
    
    if( oNodeOne.class == Array ) 
      oNodeOne.each do |no|
        add_edge( no, oNodeTwo, hOpts )
      end
    else
      if( oNodeTwo.class == Array )
        oNodeTwo.each do |nt|
          add_edge( oNodeOne, nt, hOpts )
        end
      else
        oEdge = GraphViz::Edge::new( oNodeOne, oNodeTwo, self )
        oEdge.index = @elements_order.size_of( "edge" )
        
        hOpts.each do |xKey, xValue|
          oEdge[xKey.to_s] = xValue
        end
        
        @elements_order.push( { 
          "type" => "edge", 
          "value" => oEdge
        } )
        @loEdges.push( oEdge )
        
        return( oEdge )
      end
    end
  end

  #
  # Allow you to traverse edges
  #
  def each_edge( &block )
    if block_given?
      @loEdges.each do |edge|
        yield(edge)
      end
    else
      return @loEdges
    end
  end
  
  #
  # Get the number of edges
  #
  def edge_count
    @loEdges.size
  end
  
  #
  # Return the edge object for the given index
  #
  def get_edge_at_index( index )
    element = @elements_order[index, "edge"]
    (element.nil?) ? nil : element["value"]
  end
  
  # 
  # Create a new graph
  # 
  # In:
  # * xGraphName : Graph name
  # * hOpts : Graph attributs
  #
  def add_graph( xGraphName = nil, hOpts = {}, &block )
    if xGraphName.kind_of?(Hash)
      hOpts = xGraphName
      xGraphName = nil
    end

    if xGraphName.nil?
      xGraphID = String.random(11)
      xGraphName = ""
    else
      xGraphID = xGraphName
    end
    
    @hoGraphs[xGraphID] = GraphViz::new( xGraphName, {:parent => self, :type => @oGraphType}, &block )
   
    hOpts.each do |xKey, xValue|
      @hoGraphs[xGraphID][xKey.to_s] = xValue
    end
    
    @elements_order.push( { 
      "type" => "graph", 
      "name" => xGraphName,
      "value" => @hoGraphs[xGraphID] 
    } )
    
    return( @hoGraphs[xGraphID] )
  end
  alias :subgraph :add_graph
  #
  # Return the graph object for the given name (or nil)
  #
  def get_graph( xGraphName, &block )
    graph = @hoGraphs[xGraphName] || nil
    
    yield( graph ) if( block and graph.nil? == false )
    
    return graph
  end
  
  #
  # Allow you to traverse graphs
  #
  def each_graph( &block )
    if block_given?
      @hoGraphs.each do |name, graph|
        yield( name, graph )
      end
    else
      return @hoGraphs
    end
  end
  
  #
  # Return the graph type (graph digraph)
  def type
    @oGraphType
  end
  
  #
  # Get the number of graphs
  #
  def graph_count
    @hoGraphs.size
  end
  
  def method_missing( idName, *args, &block ) #:nodoc:
    xName = idName.id2name
  
    rCod = nil
    
    if block
      # Creating a cluster named '#{xName}'
      rCod = add_graph( xName, args[0]||{} )
      yield( rCod )
    else
      # Create a node named '#{xName}' or search for a node, edge or cluster      
      if @hoNodes.keys.include?( xName )
        if( args[0] )
          return { xName => args[0] }
        else
          return( @hoNodes[xName] ) 
        end
      end
      return( @hoGraphs[xName] ) if @hoGraphs.keys.include?( xName )
            
      rCod = add_node( xName, args[0]||{} )
    end

    return rCod
  end
  
  # 
  # Set value +xValue+ to the graph attribut +xAttrName+
  # 
  def []=( xAttrName, xValue )
    xValue = xValue.to_s if xValue.class == Symbol
    @graph[xAttrName] = xValue
  end

  # 
  # Get the value of the graph attribut +xAttrName+
  # 
  def []( xAttrName )
    if Hash === xAttrName
      xAttrName.each do |key, value|
        self[key] = value
      end
    else
      return( @graph[xAttrName].clone )
    end
  end
  
  #
  # Calls block once for each attribut of the graph, passing the name and value to the 
  # block as a two-element array.
  #
  def each_attribut(&b)
    @graph.each do |k,v|
      yield(k,v)
    end
  end
  
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
  def output( hOpts = {} )
    xDOTScript = ""
    xLastType = nil
    xSeparator = ""
    xData = ""
    lNotHugly = []

    @elements_order.each { |kElement|
      if xLastType.nil? == true or xLastType != kElement["type"]
        
        if xData.length > 0 
          case xLastType
            when "graph_attr"
              xDOTScript << "  " + xData + ";\n"
  
            when "node_attr"
              xDOTScript << "  node [" + xData + "];\n"
            
            when "edge_attr"
              xDOTScript << "  edge [" + xData + "];\n"
          end
        end
        
        xSeparator = ""
        xData = ""
      end

      xLastType = kElement["type"]

      #Modified by
      #Brandon Coleman 
      #verify value is NOT NULL
      if kElement["value"] == nil then
        raise ArgumentError, "#{kElement["name"]} has a nil value!"
      end

      case kElement["type"]
        when "graph_attr"
          xData << xSeparator + kElement["name"] + " = " + kElement["value"].to_gv
          xSeparator = "; "

        when "node_attr"
          xData << xSeparator + kElement["name"] + " = " + kElement["value"].to_gv
          xSeparator = ", "

        when "edge_attr"
          xData << xSeparator + kElement["name"] + " = " + kElement["value"].to_gv
          xSeparator = ", "

        when "node"
          xDOTScript << "  " + kElement["value"].output() + "\n"

        when "edge"
          xDOTScript << "  " + kElement["value"].output( @oGraphType ) + "\n"

        when "graph"
          xDOTScript << kElement["value"].output() + "\n"

        else
          raise ArgumentError, "Don't know what to do with element type '#{kElement['type']}'"
      end
    }
    
    if xData.length > 0 
      case xLastType
        when "graph_attr"
          xDOTScript << "  " + xData + ";\n"

        when "node_attr"
          xDOTScript << "  node [" + xData + "];\n"
        
        when "edge_attr"
          xDOTScript << "  edge [" + xData + "];\n"
      end
    end
    xDOTScript << "}"

    if @oParentGraph.nil? == false
      xDOTScript = "subgraph #{GraphViz.escape(@name, :unquote_empty => true)} {\n" << xDOTScript

      return( xDOTScript )
    else
      hOutput = {}
      
      hOpts.each do |xKey, xValue|
        xValue = xValue.to_s unless xValue.nil? or [Class, TrueClass, FalseClass].include?(xValue.class)
        case xKey.to_s
          when "output"
            warn ":output option is deprecated, please use :<format> => :<file>"
            if FORMATS.index( xValue ).nil? == true
              raise ArgumentError, "output format '#{xValue}' invalid"
            end
            @format = xValue
          when "file"
            warn ":file option is deprecated, please use :<format> => :<file>"
            @filename = xValue
          when "use"
            if PROGRAMS.index( xValue ).nil? == true
              raise ArgumentError, "can't use '#{xValue}'"
            end
            @prog = xValue
          when "path"
            @path = xValue.split( "," ).map{ |x| x.strip }
          when "errors"
            @errors = xValue
          when "extlib"
            @extlibs = xValue.split( "," ).map{ |x| x.strip }
          when "nothugly"
            begin
              require 'graphviz/nothugly'
              @nothugly = true
            rescue
              warn "You must install ruby-xslt to use nothugly option!"
              @nothugly = false
            end
          else
            if FORMATS.index( xKey.to_s ).nil? == true
              raise ArgumentError, "output format '#{xValue}' invalid"
            end
            hOutput[xKey.to_s] = xValue
        end
      end
      
      @output = hOutput if hOutput.size > 0
  
      xStict = ((@strict && @oGraphType == "digraph") ? "strict " : "")
      xDOTScript = ("#{xStict}#{@oGraphType} #{GraphViz.escape(@name, :unquote_empty => true)} {\n" << xDOTScript).gsub( "\0", "" )

      xOutputString = (@filename == String ||
        @output.any? {|format, file| file == String })
        
      xOutput = ""
      if @format.to_s == "none" or @output.any? {|fmt, fn| fmt.to_s == "none"}
        if xOutputString
          xOutput << xDOTScript
        else
          xFileName = @output["none"] || @filename
          open( xFileName, "w" ) do |h|
            h.puts xDOTScript
          end
        end
      end
      
      if (@format.to_s != "none" and not @format.nil?) or (@output.any? {|format, file| format != "none" } and @output.size > 0)
        ## Act: Save script and send it to dot
        t = Tempfile::open( File.basename(__FILE__) )
        t.print( xDOTScript )
        t.close
        
        cmd = find_executable( @prog, @path )
        if cmd == nil
          raise StandardError, "GraphViz not installed or #{@prog} not in PATH. Install GraphViz or use the 'path' option"
        end

        cmd = escape_path_containing_blanks(cmd) if IS_JRUBY

        xOutputWithFile = ""
        xOutputWithoutFile = ""
        unless @format.nil? or @format == "none"
          lNotHugly << @filename if @format.to_s == "svg" and @nothugly
          if @filename.nil? or @filename == String
            xOutputWithoutFile = "-T#{@format} "
          else
            xOutputWithFile = "-T#{@format} -o#{@filename} "
          end
        end
        @output.each_except( :key => ["none"] ) do |format, file|
          lNotHugly << file if format.to_s == "svg" and @nothugly
          if file.nil? or file == String
            xOutputWithoutFile << "-T#{format} "
          else
            xOutputWithFile << "-T#{format} -o#{file} "
          end
        end
        
        xExternalLibraries = ""
        @extlibs.each do |lib|
          xExternalLibraries << "-l#{lib} "
        end
        
        if IS_JRUBY
          xCmd = "#{cmd} -q#{@errors} #{xExternalLibraries} #{xOutputWithFile} #{xOutputWithoutFile} #{t.path}"
        elsif IS_CYGWIN
          tmpPath = t.path
          begin
            tmpPath = "'" + `cygpath -w #{t.path}`.chomp + "'"
          rescue
            warn "cygpath is not installed!"
          end
          xCmd = "\"#{cmd}\" -q#{@errors} #{xExternalLibraries} #{xOutputWithFile} #{xOutputWithoutFile} #{tmpPath}"
        else
          xCmd = "\"#{cmd}\" -q#{@errors} #{xExternalLibraries} #{xOutputWithFile} #{xOutputWithoutFile} #{t.path}"
        end

        xOutput << output_from_command( xCmd )
      end
      
      # Not Hugly
      lNotHugly.each do |f|
        if f.nil? or f == String
          xOutput = GraphViz.nothugly( xOutput, false )
        else
          GraphViz.nothugly( f, true )
        end
      end
      
      if xOutputString
        xOutput
      else
        print xOutput
      end
    end
  end
  
  alias :save :output
  
  # 
  # Get the graph name
  #
  def name 
    @name.clone
  end
  alias :id :name
  
  # 
  # Create an edge between the current cluster and the node or cluster +oNode+
  # 
  def <<( oNode )
    raise( ArgumentError, "Edge between root graph and node or cluster not allowed!" ) if self.pg.nil?

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
  
  def pg #:nodoc:
    @oParentGraph
  end
  
  #
  # Return the root graph
  #
  def root_graph
    return( (self.pg.nil?) ? self : self.pg.root_graph )
  end
  
  def self.commonGraph( o1, o2 ) #:nodoc:
    g1 = o1.pg
    g2 = o2.pg

    return o1 if g1.nil?
    return o2 if g2.nil?
    
    return g1 if g1.object_id == g2.object_id
    
    return GraphViz::commonGraph( g1, g2 )
  end
  
  def set_position( xType, xKey, xValue ) #:nodoc:
    @elements_order.push( { 
      "type" => "#{xType}_attr", 
      "name" => xKey,
      "value" => xValue 
    } )
  end
  
## ----------------------------------------------------------------------------

  #
  # Change default options (:use, :path, :errors and :output)
  # 
  def self.default( hOpts )
    hOpts.each do |k, v|
      case k.to_s
        when "use"
          @@prog = v
        when "path"
          @@path = v.split( "," ).map{ |x| x.strip }
        when "errors"
          @@errors = v
        when "extlibs"
          @@extlibs = v.split( "," ).map{ |x| x.strip }
        when "output"
          warn ":output option is deprecated!"
          @@format = v
        else
          warn "Invalide option #{k}!"
      end
    end
  end
  
  def self.options( hOpts )
    GraphViz::default( hOpts )
  end
  
## ----------------------------------------------------------------------------

  # 
  # Create a new graph from a GraphViz File
  # 
  # Options :
  # * :output : Output format (Constants::FORMATS) (default : dot)
  # * :file : Output file name (default : none)
  # * :use : Program to use (Constants::PROGRAMS) (default : dot)
  # * :path : Program PATH
  #
  def self.parse( xFile, hOpts = {}, &block ) 
    graph = Dot2Ruby::new( hOpts[:path], nil, nil ).eval( xFile )
    yield( graph ) if( block and graph.nil? == false )
    return graph
  end

## ----------------------------------------------------------------------------

  private 

  ## Var: Nodes, Edges and Graphs tables
  @hoNodes
  @loEdges
  @hoGraphs

  ## Var: Parent graph
  @oParentGraph

  ## Var: Type de graphe (orienté ou non)
  @oGraphType
  
  # 
  # Create a new graph object
  # 
  # Options :
  # * :output : Output format (Constants::FORMATS) (default : dot)
  # * :file : Output file name (default : nil)
  # * :use : Program to use (Constants::PROGRAMS) (default : dot)
  # * :path : Program PATH
  # * :parent : Parent graph (default : nil)
  # * :type : Graph type (Constants::GRAPHTYPE) (default : digraph)
  # * :errors : DOT error level (default 1)
  #   * 0 = Error + Warning
  #   * 1 = Error
  #   * 2 = none
  # 
  def initialize( xGraphName, hOpts = {}, &block )
    @filename = nil
    @name     = xGraphName.to_s
    @format   = @@format
    @prog     = @@prog
    @path     = @@path
    @errors   = @@errors
    @extlibs  = @@extlibs
    @output   = {}
    @nothugly = false
    @strict   = false
    
    @elements_order = GraphViz::Elements::new()

    @oParentGraph = nil
    @oGraphType   = "digraph"
    
    @hoNodes  = Hash::new()
    @loEdges  = Array::new()
    @hoGraphs = Hash::new()
    
    @node  = GraphViz::Attrs::new( self, "node",  NODESATTRS  )
    @edge  = GraphViz::Attrs::new( self, "edge",  EDGESATTRS  )
    @graph = GraphViz::Attrs::new( self, "graph", GRAPHSATTRS )

    hOpts.each do |xKey, xValue|
      case xKey.to_s
        when "output"
          warn ":output option is deprecated, please use :<format> => :<file>"
          if FORMATS.index( xValue.to_s ).nil? == true
            raise ArgumentError, "output format '#{xValue}' invalid"
          end
          @format = xValue.to_s
        when "use"
          if PROGRAMS.index( xValue.to_s ).nil? == true
            raise ArgumentError, "can't use '#{xValue}'"
          end
          @prog = xValue.to_s
        when "file"
          warn ":file option is deprecated, please use :<format> => :<file>"
          @filename = xValue.to_s
        when "parent"
          @oParentGraph = xValue
        when "type"
          if GRAPHTYPE.index( xValue.to_s ).nil? == true
            raise ArgumentError, "graph type '#{xValue}' unknow"
          end
          @oGraphType = xValue.to_s
        when "path"
          @path = xValue.split( "," ).map{ |x| x.strip }
        when "strict"
          @strict = (xValue ? true : false)
        when "errors"
          @errors = xValue
        when "extlibs"
          @extlibs = xValue.split( "," ).map{ |x| x.strip }
        else
          self[xKey.to_s] = xValue.to_s
      end
    end
  
    yield( self ) if( block )
  end
  
  #
  # Create a new undirected graph
  #
  # See also GraphViz::new
  #
  def self.graph( xGraphName, hOpts = {}, &block )
    new( xGraphName, hOpts.symbolize_keys.merge( {:type => "graph"} ), &block )
  end

  #
  # Create a new directed graph
  #
  # See also GraphViz::new
  #
  def self.digraph( xGraphName, hOpts = {}, &block )
    new( xGraphName, hOpts.symbolize_keys.merge( {:type => "digraph"} ), &block )
  end
  
  #
  # Create a new strict directed graph
  #
  # See also GraphViz::new
  #
  def self.strict_digraph( xGraphName, hOpts = {}, &block )
    new( xGraphName, hOpts.symbolize_keys.merge( {:type => "digraph", :strict => true} ), &block )
  end
  
  #
  # Escape a string to be acceptable as a node name in a graphviz input file
  #
  def self.escape(str, opts = {} ) #:nodoc:
    options = {
      :force => false,
      :unquote_empty => false,
    }.merge(opts)
    
    if (options[:force] or str.match( /\A[a-zA-Z_]+[a-zA-Z0-9_]*\Z/ ).nil?) and options[:unquote_empty] == false
      '"' + str.gsub('"', '\\"').gsub("\n", '\\\\n').gsub(".","\\.") + '"' 
      ## MAYBE WE NEED TO USE THIS ONE ## str.inspect.gsub(".","\\.").gsub( "\\\\", "\\" )
    else
      str
    end
  end
  
  #def self.escape(str, force = false ) #:nodoc:
  #  if force or str.match( /\A[a-zA-Z_]+[a-zA-Z0-9_]*\Z/ ).nil?
  #    '"' + str.gsub('"', '\\"').gsub("\n", '\\\\n').gsub(".","\\.") + '"' 
  #    ## MAYBE WE NEED TO USE THIS ONE ## str.inspect.gsub(".","\\.").gsub( "\\\\", "\\" )
  #  else
  #    str
  #  end
  #end
  
end
