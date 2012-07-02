require 'test/unit'
$:.unshift(File.expand_path('../../lib',__FILE__))
require 'graphviz'

class GraphVizSubGraphTest < Test::Unit::TestCase
  def test_subgraph
    master1 = GraphViz::new(:G)
    cl1 = master1.add_graph('cluster_cl1')

    master2 = GraphViz::new(:G)
    cl2 = GraphViz::new('cluster_cl1')
    master2.add_graph cl2

    assert_equal(master1.inspect, master2.inspect, "Wrong subgraph")
  end
end
