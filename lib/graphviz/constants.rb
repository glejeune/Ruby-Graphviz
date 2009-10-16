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

module Constants
  RGV_VERSION = "0.9.3"
  
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
    r = []
    GENCS_ATTRS.each { |k,v|
      r << k if /#{x}/.match( x.to_s ) and not r.include?( k )
    }
    r
  end
  
  # E, N, G, S and C represent edges, nodes, the root graph, subgraphs and cluster subgraphs, respectively
  GENCS_ATTRS = {
    "Damping"             => "G",
    "K"                   => "GC",
    "URL"                 => "ENGC",
    "arrowhead"           => "E",
    "arrowsize"           => "E",
    "arrowtail"           => "E",
    "bb"                  => "G",
    "bgcolor"             => "GC",
#    "bottomlabel"         => "N",
    "center"              => "G",
    "charset"             => "G",
    "clusterrank"         => "G",
    "color"               => "ENC",
    "colorscheme"         => "ENCG",
    "comment"             => "ENG",
    "compound"            => "G",
    "concentrate"         => "G",
    "constraint"          => "E",
    "decorate"            => "E",
    "defaultdist"         => "G",
    "dim"                 => "G",
    "dir"                 => "E",
    "diredgeconstraints"  => "G",
    "distortion"          => "N",
    "dpi"                 => "G",
    "edgeURL"             => "E",
    "edgehref"            => "E",
    "edgetarget"          => "E",
    "edgetooltip"         => "E",
    "epsilon"             => "G",
    "esep"                => "G",
    "fillcolor"           => "NC",
    "fixedsize"           => "N",
    "fontcolor"           => "ENGC",
    "fontname"            => "ENGC",
    "fontnames"           => "G",
    "fontpath"            => "G",
    "fontsize"            => "ENGC",
    "group"               => "N",
    "headURL"             => "E",
    "headclip"            => "E",
    "headhref"            => "E",
    "headlabel"           => "E",
    "headport"            => "E",
    "headtarget"          => "E",
    "headtooltip"         => "E",
    "height"              => "N",
    "href"                => "E",
    "html"                => "N", # API extension
    "image"               => "N",
    "imagescale"          => "N",
    "label"               => "ENGC",
    "labelURL"            => "E",
    "labelangle"          => "E",
    "labeldistance"       => "E",
    "labelfloat"          => "E",
    "labelfontcolor"      => "E",
    "labelfontname"       => "E",
    "labelfontsize"       => "E",
    "labelhref"           => "E",
    "labeljust"           => "GC",
    "labelloc"            => "GCN",
    "labeltarget"         => "E",
    "labeltooltip"        => "E",
    "landscape"           => "G",
    "layer"               => "EN",
    "layers"              => "G",
    "layersep"            => "G",
    "len"                 => "E",
    "levelsgap"           => "G",
    "lhead"               => "E",
    "lp"                  => "EGC",
    "ltail"               => "E",
    "margin"              => "NG",
    "maxiter"             => "G",
    "mclimit"             => "G",
    "mindist"             => "G",
    "minlen"              => "E",
    "mode"                => "G",
    "model"               => "G",
    "mosek"               => "G",
    "nodesep"             => "G",
    "nojustify"           => "GCNE",
    "normalize"           => "G",
    "nslimit"             => "G",
    "nslimit1"            => "G",
    "ordering"            => "G",
    "orientation"         => "NG",
    "outputorder"         => "G",
    "overlap"             => "G",
    "pack"                => "G",
    "packmode"            => "G",
    "pad"                 => "G",
    "page"                => "G",
    "pagedir"             => "G",
    "pencolor"            => "C",
    "penwidth"            => "CNE",
    "peripheries"         => "NC",
    "pin"                 => "N",
    "pos"                 => "EN",
    "quantum"             => "G",
    "rank"                => "S",
    "rankdir"             => "G",
    "ranksep"             => "G",
    "ratio"               => "G",
    "rects"               => "N",
    "regular"             => "N",
    "remincross"          => "G",
    "resolution"          => "G",
    "root"                => "GN",
    "rotate"              => "G",
    "samehead"            => "E",
    "sametail"            => "E",
    "samplepoints"        => "G",
    "searchsize"          => "G",
    "sep"                 => "G",
    "shape"               => "N",
    "shapefile"           => "N",
    "showboxes"           => "ENG",
    "sides"               => "N",
    "size"                => "G",
    "skew"                => "N",
    "splines"             => "G",
    "start"               => "G",
    "style"               => "ENC",
    "stylesheet"          => "G",
    "tailURL"             => "E",
    "tailclip"            => "E",
    "tailhref"            => "E",
    "taillabel"           => "E",
    "tailport"            => "E",
    "tailtarget"          => "E",
    "tailtooltip"         => "E",
    "target"              => "ENGC",
    "tooltip"             => "NEC",
#    "toplabel"            => "N",
    "truecolor"           => "G",
    "vertices"            => "N",
    "viewport"            => "G",
    "voro_margin"         => "G",
    "weight"              => "E",
    "width"               => "N",
    "z"                   => "N"
  }

  ## Const: Graph attributs
  GRAPHSATTRS = Constants::getAttrsFor( :G ) + Constants::getAttrsFor( :S ) + Constants::getAttrsFor( :C )

  ## Const: Node attributs
  NODESATTRS = Constants::getAttrsFor( :N )

  ## Const: Edge attributs
  EDGESATTRS = Constants::getAttrsFor( :E )
end
