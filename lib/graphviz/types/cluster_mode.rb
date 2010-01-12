class GraphViz
  class Types
    class ClusterMode < Common
      TYPELIST = ["local", "global", "none"]
      def check(data)
        unless TYPELIST.include?(data)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with clusterMode type!"
        end
        return data
      end
    end
  end
end