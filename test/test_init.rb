require 'test/unit'
$:.unshift(File.expand_path('../../lib',__FILE__))
require 'graphviz'

class GraphVizTest < Test::Unit::TestCase
  def setup
    @graph = GraphViz::new( :G )    
  end

  # def teardown
  # end

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
end