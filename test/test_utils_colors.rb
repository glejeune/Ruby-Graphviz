require 'test/unit'
$:.unshift(File.expand_path('../../lib',__FILE__))
require 'graphviz/utils/colors'

class TypesTest < Test::Unit::TestCase
  def test_color_by_name
    brown = GraphViz::Utils::Colors.name("brown")
    assert brown
    
    assert_equal "brown", brown.name
    
    assert_equal "a5", brown.r 
    assert_equal "2a", brown.g
    assert_equal "2a", brown.b
    assert_equal "#a52a2a", brown.rgba_string("#")

    assert_equal 0.0.to_s, brown.h.to_s
    assert_equal 0.745454545454545.to_s, brown.s.to_s
    assert_equal 0.647058823529412.to_s, brown.v.to_s

    assert_equal "0.0, 0.745454545454545, 0.647058823529412", brown.hsv_string
  end

  def test_color_by_hsv
    brown = GraphViz::Utils::Colors.hsv(0.0, 0.745454545454545, 0.647058823529412)
    assert brown
    
    assert_equal "brown", brown.name
    
    assert_equal "a5", brown.r 
    assert_equal "2a", brown.g
    assert_equal "2a", brown.b
    assert_equal "#a52a2a", brown.rgba_string("#")
    
    assert_equal 0.0.to_s, brown.h.to_s
    assert_equal 0.745454545454545.to_s, brown.s.to_s
    assert_equal 0.647058823529412.to_s, brown.v.to_s
    assert_equal "0.0, 0.745454545454545, 0.647058823529412", brown.hsv_string
  end

  def test_color_by_rgb
    brown = GraphViz::Utils::Colors.rgb("a5", "2a", "2a") 
    assert brown
    
    assert_equal "brown", brown.name
    
    assert_equal "a5", brown.r 
    assert_equal "2a", brown.g
    assert_equal "2a", brown.b
    assert_equal "#a52a2a", brown.rgba_string("#")
    
    assert_equal 0.0.to_s, brown.h.to_s
    assert_equal 0.745454545454545.to_s, brown.s.to_s
    assert_equal 0.647058823529412.to_s, brown.v.to_s
    assert_equal "0.0, 0.745454545454545, 0.647058823529412", brown.hsv_string
  end
end
