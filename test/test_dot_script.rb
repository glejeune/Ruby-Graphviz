require 'helper'

class GraphVizDOTScriptTest < Test::Unit::TestCase
  context "a new dot script" do
    setup do
      @script = GraphViz::DOTScript.new
    end

    should "appends a newline character if it is missing" do
      str = "Test without newline"
      @script.append(str)
      assert_equal @script.to_s, str + "\n"
    end

    should "does not append a newline if already present" do
      str = "Linebreak follows at my tail:\n"
      @script.append(str)
      assert_equal @script.to_s, str
    end

    should "can prepend lines to its content" do
      start_content = "I want to be at the top!\n"
      additional_content = "No way!\n"

      @script.append(start_content)
      @script.prepend(additional_content)

      assert_equal @script.to_s, additional_content + start_content
    end

    should "can add types with data" do
      data = "some random data"
      @script.add_type("node_attr", data)
      assert_match /\s*node\s*\[\s*#{data}\s*\]\s*/, @script.to_s
    end

    should "does nothing if data is empty" do
      @script.add_type("anything", "")
      assert_equal true, @script.to_s.empty?
    end

    should "raises an argument error on unknown types" do
      assert_raise ArgumentError do
        @script.add_type("invalid", "some data")
      end
    end
  end
end

