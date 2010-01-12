class GraphViz
  class Types
    class QuadType < Common
      TYPELIST = ["normal", "fast", "none"]
      def check(data)
        unless TYPELIST.include?(data)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with quadType type!"
        end
        return data
      end
    end
  end
end