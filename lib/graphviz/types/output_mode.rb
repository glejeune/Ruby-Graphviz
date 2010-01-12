class GraphViz
  class Types
    class OutputMode < Common
      TYPELIST = ["breadthfirst", "nodesfirst", "edgesfirst"]
      def check(data)
        unless TYPELIST.include?(data)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with outputMode type!"
        end
        return data
      end
    end
  end
end