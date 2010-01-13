# Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009 Gregoire Lejeune <gregoire.lejeune@free.fr>
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

# Constants for ruby-graphviz
# 
# Constants::FORMATS: the possible output formats
#   "bmp", "canon", "dot", "xdot", "cmap", "dia", "eps", 
#   "fig", "gd", "gd2", "gif", "gtk", "hpgl", "ico", "imap",
#   "cmapx", "imap_np", "cmapx_np", "ismap", "jpeg", "jpg",
#   "jpe", "mif", "mp", "pcl", "pdf", "pic", "plain",
#   "plain-ext", "png", "ps", "ps2", "svg", "svgz", "tga",
#   "tiff", "tif", "vml", "vmlz", "vrml", "vtx", "wbmp",
#   "xlib", "none" 
# 
# Constants::PROGRAMS: The possible programs
#   "dot", "neato", "twopi", "fdp", "circo"
#
# Constants::GRAPHTYPE The possible types of graph
#   "digraph", "graph"
#
#
# The single letter codes used in constructors map as follows:
#   G => The root graph, with GRAPHATTRS 
#   E => Edge, with EDGESATTRS
#   N => Node, with NODESATTRS
#   S => subgraph
#   C => cluster
#
module Constants
  RGV_VERSION = "0.9.8"
  
  ## Const: Output formats
  FORMATS = [
    "bmp",
    "canon",
    "dot", 
    "xdot",
    "cmap", 
    "dia",
    "eps",
    "fig",
    "gd",
    "gd2",
    "gif",
    "gtk",
    "hpgl", 
    "ico",
    "imap", 
    "cmapx",
    "imap_np", 
    "cmapx_np",
    "ismap", 
    "jpeg", 
    "jpg", 
    "jpe", 
    "mif", 
    "mp",
    "pcl", 
    "pdf",
    "pic", 
    "plain", 
    "plain-ext",
    "png", 
    "ps", 
    "ps2",
    "svg", 
    "svgz",
    "tga",
    "tiff",
    "tif",
    "vml",
    "vmlz",
    "vrml", 
    "vtx", 
    "wbmp", 
    "xlib", 
    "none"
  ]

  ## Const: programs
  PROGRAMS = [
    "dot",
    "neato",
    "twopi",
    "fdp",
    "circo"
  ]

  ## Const: graphs type
  GRAPHTYPE = [
    "digraph",
	  "graph"
  ]

  def self.getAttrsFor( x )
    list = {}
    GENCS_ATTRS.each { |k,v|
      list[k] = v[:type] if x.match( v[:usedBy] ) and not list.keys.include?(k)
    }
    list
  end
  
  # E, N, G, S and C represent edges, nodes, the root graph, subgraphs and cluster subgraphs, respectively
  GENCS_ATTRS = {
    "Damping"             => { :usedBy => "G",    :type => [:GvDouble] },
    "K"                   => { :usedBy => "GC",   :type => [:GvDouble] },
    "URL"                 => { :usedBy => "ENGC", :type => [:EscString] },
    "arrowhead"           => { :usedBy => "E",    :type => [:ArrowType] },
    "arrowsize"           => { :usedBy => "E",    :type => [:GvDouble] },
    "arrowtail"           => { :usedBy => "E",    :type => [:ArrowType] },
    "aspect"              => { :usedBy => "G",    :type => [:AspectType] },
    "bb"                  => { :usedBy => "G",    :type => [:Rect] },
    "bgcolor"             => { :usedBy => "GC",   :type => [:Color] },
    "center"              => { :usedBy => "G",    :type => [:Bool] },
    "charset"             => { :usedBy => "G",    :type => [:GvString] },
    "clusterrank"         => { :usedBy => "G",    :type => [:ClusterMode] },
    "color"               => { :usedBy => "ENC",  :type => [:Color, :ColorList] },
    "colorscheme"         => { :usedBy => "ENCG", :type => [:GvString] },
    "comment"             => { :usedBy => "ENG",  :type => [:GvString] },
    "compound"            => { :usedBy => "G",    :type => [:Bool] },
    "concentrate"         => { :usedBy => "G",    :type => [:Bool] },
    "constraint"          => { :usedBy => "E",    :type => [:Bool] },
    "decorate"            => { :usedBy => "E",    :type => [:Bool] },
    "defaultdist"         => { :usedBy => "G",    :type => [:GvDouble] },
    "dim"                 => { :usedBy => "G",    :type => [:GvInt] },
    "dimen"               => { :usedBy => "G",    :type => [:GvInt] },
    "dir"                 => { :usedBy => "E",    :type => [:DirType] },
    "diredgeconstraints"  => { :usedBy => "G",    :type => [:GvString, :Bool] },
    "distortion"          => { :usedBy => "N",    :type => [:GvDouble] },
    "dpi"                 => { :usedBy => "G",    :type => [:GvDouble] },
    "edgeURL"             => { :usedBy => "E",    :type => [:EscString] },
    "edgehref"            => { :usedBy => "E",    :type => [:EscString] },
    "edgetarget"          => { :usedBy => "E",    :type => [:EscString] },
    "edgetooltip"         => { :usedBy => "E",    :type => [:EscString] },
    "epsilon"             => { :usedBy => "G",    :type => [:GvDouble] },
    "esep"                => { :usedBy => "G",    :type => [:GvDouble, :Pointf] },
    "fillcolor"           => { :usedBy => "NC",   :type => [:Color] },
    "fixedsize"           => { :usedBy => "N",    :type => [:Bool] },
    "fontcolor"           => { :usedBy => "ENGC", :type => [:Color] },
    "fontname"            => { :usedBy => "ENGC", :type => [:GvString] },
    "fontnames"           => { :usedBy => "G",    :type => [:GvString] },
    "fontpath"            => { :usedBy => "G",    :type => [:GvString] },
    "fontsize"            => { :usedBy => "ENGC", :type => [:GvDouble] },
    "group"               => { :usedBy => "N",    :type => [:GvString] },
    "headURL"             => { :usedBy => "E",    :type => [:EscString] },
    "headclip"            => { :usedBy => "E",    :type => [:Bool] },
    "headhref"            => { :usedBy => "E",    :type => [:EscString] },
    "headlabel"           => { :usedBy => "E",    :type => [:LblString] },
    "headport"            => { :usedBy => "E",    :type => [:PortPos] },
    "headtarget"          => { :usedBy => "E",    :type => [:EscString] },
    "headtooltip"         => { :usedBy => "E",    :type => [:EscString] },
    "height"              => { :usedBy => "N",    :type => [:GvDouble] },
    "href"                => { :usedBy => "E",    :type => [:EscString] },
    "html"                => { :usedBy => "N",    :type => [:HtmlString] }, # API extension
    "id"                  => { :usedBy => "ENG",  :type => [:LblString] },
    "image"               => { :usedBy => "N",    :type => [:GvString] },
    "imagescale"          => { :usedBy => "N",    :type => [:Bool, :GvString] },
    "label"               => { :usedBy => "ENGC", :type => [:LblString] },
    "labelURL"            => { :usedBy => "E",    :type => [:EscString] },
    "labelangle"          => { :usedBy => "E",    :type => [:GvDouble] },
    "labeldistance"       => { :usedBy => "E",    :type => [:GvDouble] },
    "labelfloat"          => { :usedBy => "E",    :type => [:Bool] },
    "labelfontcolor"      => { :usedBy => "E",    :type => [:Color] },
    "labelfontname"       => { :usedBy => "E",    :type => [:GvString] },
    "labelfontsize"       => { :usedBy => "E",    :type => [:GvDouble] },
    "labelhref"           => { :usedBy => "E",    :type => [:EscString] },
    "labeljust"           => { :usedBy => "GC",   :type => [:GvString] },
    "labelloc"            => { :usedBy => "GCN",  :type => [:GvString] },
    "labeltarget"         => { :usedBy => "E",    :type => [:EscString] },
    "labeltooltip"        => { :usedBy => "E",    :type => [:EscString] },
    "landscape"           => { :usedBy => "G",    :type => [:Bool] },
    "layer"               => { :usedBy => "EN",   :type => [:LayerRange] },
    "layers"              => { :usedBy => "G",    :type => [:LayerList] },
    "layersep"            => { :usedBy => "G",    :type => [:GvString] },
    "layout"              => { :usedBy => "G",    :type => [:GvString] },
    "len"                 => { :usedBy => "E",    :type => [:GvDouble] },
    "levels"              => { :usedBy => "G",    :type => [:GvInt] },
    "levelsgap"           => { :usedBy => "G",    :type => [:GvDouble] },
    "lhead"               => { :usedBy => "E",    :type => [:GvString] },
    "lp"                  => { :usedBy => "EGC",  :type => [:Point] },
    "ltail"               => { :usedBy => "E",    :type => [:GvString] },
    "margin"              => { :usedBy => "NG",   :type => [:GvDouble, :Pointf] },
    "maxiter"             => { :usedBy => "G",    :type => [:GvInt] },
    "mclimit"             => { :usedBy => "G",    :type => [:GvDouble] },
    "mindist"             => { :usedBy => "G",    :type => [:GvDouble] },
    "minlen"              => { :usedBy => "E",    :type => [:GvInt] },
    "mode"                => { :usedBy => "G",    :type => [:GvString] },
    "model"               => { :usedBy => "G",    :type => [:GvString] },
    "mosek"               => { :usedBy => "G",    :type => [:Bool] },
    "nodesep"             => { :usedBy => "G",    :type => [:GvDouble] },
    "nojustify"           => { :usedBy => "GCNE", :type => [:Bool] },
    "normalize"           => { :usedBy => "G",    :type => [:Bool] },
    "nslimit"             => { :usedBy => "G",    :type => [:GvDouble] },
    "nslimit1"            => { :usedBy => "G",    :type => [:GvDouble] },
    "ordering"            => { :usedBy => "G",    :type => [:GvString] },
    "orientation"         => { :usedBy => "NG",   :type => [:GvDouble] },
    "outputorder"         => { :usedBy => "G",    :type => [:OutputMode] },
    "overlap"             => { :usedBy => "G",    :type => [:GvString, :Bool] },
    "overlap_scaling"     => { :usedBy => "G",    :type => [:GvDouble] },
    "pack"                => { :usedBy => "G",    :type => [:Bool, :GvInt] },
    "packmode"            => { :usedBy => "G",    :type => [:PackMode] },
    "pad"                 => { :usedBy => "G",    :type => [:GvDouble, :Pointf] },
    "page"                => { :usedBy => "G",    :type => [:GvDouble, :Pointf] },
    "pagedir"             => { :usedBy => "G",    :type => [:Pagedir] },
    "pencolor"            => { :usedBy => "C",    :type => [:Color] },
    "penwidth"            => { :usedBy => "CNE",  :type => [:GvDouble] },
    "peripheries"         => { :usedBy => "NC",   :type => [:GvInt] },
    "pin"                 => { :usedBy => "N",    :type => [:Bool] },
    "pos"                 => { :usedBy => "EN",   :type => [:Point, :SplineType] },
    "quadtree"            => { :usedBy => "G",    :type => [:QuadType, :Bool] },
    "quantum"             => { :usedBy => "G",    :type => [:GvDouble] },
    "rank"                => { :usedBy => "S",    :type => [:RankType] },
    "rankdir"             => { :usedBy => "G",    :type => [:Rankdir] },
    "ranksep"             => { :usedBy => "G",    :type => [:GvDouble, :DoubleList] },
    "ratio"               => { :usedBy => "G",    :type => [:GvDouble, :GvString] },
    "rects"               => { :usedBy => "N",    :type => [:Rect] },
    "regular"             => { :usedBy => "N",    :type => [:Bool] },
    "remincross"          => { :usedBy => "G",    :type => [:Bool] },
    "repulsiveforce"      => { :usedBy => "G",    :type => [:GvDouble] },
    "resolution"          => { :usedBy => "G",    :type => [:GvDouble] },
    "root"                => { :usedBy => "GN",   :type => [:GvString, :Bool] },
    "rotate"              => { :usedBy => "G",    :type => [:GvInt] },
    "samehead"            => { :usedBy => "E",    :type => [:GvString] },
    "sametail"            => { :usedBy => "E",    :type => [:GvString] },
    "samplepoints"        => { :usedBy => "G",    :type => [:GvInt] },
    "searchsize"          => { :usedBy => "G",    :type => [:GvInt] },
    "sep"                 => { :usedBy => "G",    :type => [:GvDouble, :Pointf] },
    "shape"               => { :usedBy => "N",    :type => [:Shape] },
    "shapefile"           => { :usedBy => "N",    :type => [:GvString] },
    "showboxes"           => { :usedBy => "ENG",  :type => [:GvInt] },
    "sides"               => { :usedBy => "N",    :type => [:GvInt] },
    "size"                => { :usedBy => "G",    :type => [:GvDouble, :Pointf] },
    "skew"                => { :usedBy => "N",    :type => [:GvDouble] },
    "smoothing"           => { :usedBy => "G",    :type => [:SmoothType] },
    "sortv"               => { :usedBy => "GCN",  :type => [:GvInt] },
    "splines"             => { :usedBy => "G",    :type => [:Bool, :GvString] },
    "start"               => { :usedBy => "G",    :type => [:StartType] },
    "style"               => { :usedBy => "ENC",  :type => [:Style] },
    "stylesheet"          => { :usedBy => "G",    :type => [:GvString] },
    "tailURL"             => { :usedBy => "E",    :type => [:EscString] },
    "tailclip"            => { :usedBy => "E",    :type => [:Bool] },
    "tailhref"            => { :usedBy => "E",    :type => [:EscString] },
    "taillabel"           => { :usedBy => "E",    :type => [:LblString] },
    "tailport"            => { :usedBy => "E",    :type => [:PortPos] },
    "tailtarget"          => { :usedBy => "E",    :type => [:EscString] },
    "tailtooltip"         => { :usedBy => "E",    :type => [:EscString] },
    "target"              => { :usedBy => "ENGC", :type => [:EscString, :GvString] },
    "tooltip"             => { :usedBy => "NEC",  :type => [:EscString] },
    "truecolor"           => { :usedBy => "G",    :type => [:Bool] },
    "vertices"            => { :usedBy => "N",    :type => [:PointfList] },
    "viewport"            => { :usedBy => "G",    :type => [:ViewPort] },
    "voro_margin"         => { :usedBy => "G",    :type => [:GvDouble] },
    "weight"              => { :usedBy => "E",    :type => [:GvDouble] },
    "width"               => { :usedBy => "N",    :type => [:GvDouble] },
    "z"                   => { :usedBy => "N",    :type => [:GvDouble] }
  }

  ## Const: Graph attributs
  GRAPHSATTRS = Constants::getAttrsFor( /G|S|C/ )

  ## Const: Node attributs
  NODESATTRS = Constants::getAttrsFor( /N/ )

  ## Const: Edge attributs
  EDGESATTRS = Constants::getAttrsFor( /E/ )
end
