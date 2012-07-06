require "forwardable"
class GraphViz
  class DOTScript
    extend Forwardable

    def_delegators :@script, :end_with?

    def initialize
      @script = ''
    end

    def append(line)
      @script << assure_ends_with(line, "\n")

      self
    end
    alias :<< :append

    def prepend(line)
      @script = assure_ends_with(line,"\n") + @script

      self
    end

    def add_type(type, data)
      case type
      when "graph_attr"
        append_statement("  " + data)
      when "node_attr"
        append_statement("  node [" + data + "]")
      when "edge_attr"
        append_statement("  edge [" + data + "]")
      else
        raise ArgumentError,
          "Unknown type: #{type}." <<
          "Possible: 'graph_attr','node_attr','edge_attr'"
      end

      self
    end

    def to_str
      @script
    end
    alias :to_s :to_str

    private

    def assure_ends_with(str,ending="\n")
      str.end_with?("\n") ? str : str + "\n"
    end

    def append_statement(statement)
      append(assure_ends_with(statement, ";\n"))
    end

  end
end
