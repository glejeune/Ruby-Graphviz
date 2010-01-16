require 'test/unit'
$:.unshift("../lib")
require 'graphviz'

class TC_MyTest < Test::Unit::TestCase
  def setup
    @graph = GraphViz::new( :G )
  end

  # def teardown
  # end

  def test_graph
    n, m = nil, nil
    
    assert(@graph, 'Create graph faild.')

    assert_block 'Create node failed.' do
      n = @graph.add_node( "n1" )
    end

    assert_block 'Get node failed.' do    
      m = @graph.get_node( "n1" )
    end

    assert_equal( m, n )
  end
end