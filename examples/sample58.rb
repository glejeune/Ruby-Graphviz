#!/usr/bin/ruby

# By Jonas Elfström - http://github.com/jonelf
$:.unshift( "../lib" )
require 'graphviz'

@min_level=1
@max_level=12
@max_depth=10
start_level=6

@g = GraphViz.new(:G, :type => "strict digraph")
# or @g = GraphViz.new(:G, :type => "digraph", :strict => true)
# or @g = GraphViz.digraph(:G, :strict => true)
# or @g = GraphViz.strict_digraph(:G)

def add_node(level, depth, parent)
  if depth<@max_depth
    current=[level, depth].join(",")

    sub=level<=>@min_level
    add=@max_level<=>level
    add_node(level-sub, depth+1, current)
    add_node(level+add, depth+1, current)

    @g.add_node(current).label=level.to_s
    @g.add_edge(parent, current) unless parent=="00"
  end
end

add_node(start_level, 0, "00")

@g.output( :png => "#{$0}.png" )