require 'test/unit'
$:.unshift(File.expand_path('../../lib',__FILE__))
require 'graphviz'

class GraphVizTest < Test::Unit::TestCase
  def setup
    @graph = GraphViz::new( :G )    
  end

  def test_graph
    assert(@graph, 'Create graph faild.')
    
    assert_block 'Set attribut for graph faild.' do
      @graph['size'] = "10,10"
    end
    
    assert_equal( "\"10,10\"", @graph['size'].to_s, 'Get attribut for graph faild.' )
    
    assert_equal( "G", @graph.name, "Wrong graph name." )
  end

  def test_node
    n, m = nil, nil
    
    assert_block 'Create node failed.' do
      n = @graph.add_node( "n1" )
    end

    assert_block 'Get node failed.' do    
      m = @graph.get_node( "n1" )
    end

    assert_equal( m, n, "Node corrupted when get." )
    
    assert_equal( @graph.node_count, 1, "Wrong number of nodes" )
    
    assert_block 'Set attribut for node faild.' do
      n['label'] = "Hello\n\"world\"\\l"
    end
    
    assert_equal( "\"Hello\\n\\\"world\\\"\\l\"", n['label'].to_s, 'Get attribut for node faild.' )
  end

  def test_search
     g = GraphViz::new( "G" )
     g.node["shape"] = "ellipse"
     g.node["color"] = "black"

     g["color"] = "black"

     c0 = g.add_graph( "cluster0" )
     c0["label"] = "process #1"
     c0["style"] = "filled"
     c0["color"] = "lightgrey"
     a0 = c0.add_node( "a0", "style" => "filled", "color" => "white" )
     a1 = c0.add_node( "a1", "style" => "filled", "color" => "white" )
     a2 = c0.add_node( "a2", "style" => "filled", "color" => "white" )
     a3 = c0.add_node( "a3", "style" => "filled", "color" => "white" )
     c0.add_edge( a0, a1 )
     c0.add_edge( a1, a2 )
     c0.add_edge( a2, a3 )

     c1 = g.add_graph( "cluster1", "label" => "process #2" )
     b0 = c1.add_node( "b0", "style" => "filled", "color" => "blue" )
     b1 = c1.add_node( "b1", "style" => "filled", "color" => "blue" )
     b2 = c1.add_node( "b2", "style" => "filled", "color" => "blue" )
     b3 = c1.add_node( "b3", "style" => "filled", "color" => "blue" )
     c1.add_edge( b0, b1 )
     c1.add_edge( b1, b2 )
     c1.add_edge( b2, b3 )

     start = g.add_node( "start", "shape" => "Mdiamond" )
     endn  = g.add_node( "end",   "shape" => "Msquare" )

     g.add_edge( start, a0 )
     g.add_edge( start, b0 )
     g.add_edge( a1, b3 )
     g.add_edge( b2, a3 )
     g.add_edge( a3, a0 )
     g.add_edge( a3, endn )

     assert g

     assert_equal g.get_node("start"), start
     assert_equal g.find_node("start"), start
     assert_equal g.search_node("start"), start

     assert_nil   g.get_node("a0")
     assert_equal g.find_node("a0"), a0
     assert_equal g.search_node("a0"), a0

     assert_nil   c0.get_node("start")
     assert_equal c0.find_node("start"), start
     assert_nil   c0.search_node("start")

     assert_equal c0.get_node("a0"), a0
     assert_equal c0.find_node("a0"), a0
     assert_equal c0.search_node("a0"), a0

     assert_nil   c1.get_node("start")
     assert_equal c1.find_node("start"), start
     assert_nil   c1.search_node("start")

     assert_nil   c1.get_node("a0")
     assert_equal c1.find_node("a0"), a0
     assert_nil   c1.search_node("a0")
  end
end
