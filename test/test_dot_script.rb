require "minitest/autorun"
require_relative "../lib/graphviz/dot_script"

describe GraphViz::DOTScript do
    let(:script) { GraphViz::DOTScript.new }

    it "appends a newline character if it is missing" do
      str = "Test without newline"
      script.append(str)
      script.to_s.must_equal(str + "\n")
    end

    it "does not append a newline if already present" do
      str = "Linebreak follows at my tail:\n"
      script.append(str)
      script.to_s.must_equal(str)
    end

    it "can prepend lines to its content" do
      start_content = "I want to be at the top!\n"
      additional_content = "No way!\n"

      script.append(start_content)
      script.prepend(additional_content)

      script.to_s.must_equal(additional_content + start_content)
    end

    it "can add types with data" do
      data = "some random data"
      script.add_type("node_attr", data)
      script.to_s.must_match(/\s*node\s*\[\s*#{data}\s*\]\s*/m)
    end

    it "does nothing if data is empty" do
      script.add_type("anything", "")
      script.to_s.must_be :empty?
    end

    it "raises an argument error on unknown types" do
      -> { script.add_type("invalid", "some data") }.must_raise(ArgumentError)
    end
end
