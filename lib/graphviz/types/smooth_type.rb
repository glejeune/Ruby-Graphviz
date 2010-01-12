class GraphViz
  class Types
    class SmoothType < Common
      TYPELIST = ["none", "avg_dist", "graph_dist", "power_dist", "rng", "spring", "triangle"]
      def check(data)
        unless TYPELIST.include?(data)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with smoothType type!"
        end
        return data
      end
    end
  end
end