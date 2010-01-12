class GraphViz
  class Types
    class RankType < Common
      TYPELIST = ["same", "min", "source", "max", "sink"]
      def check(data)
        unless TYPELIST.include?(data)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with rankType type!"
        end
        return data
      end
    end
  end
end