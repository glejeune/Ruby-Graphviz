class GraphViz
  class Types
    class DirType < Common
      TYPELIST = ["forward", "back", "both", "none"]
      def check(data)
        unless TYPELIST.include?(data)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with dirType type!"
        end
        return data
      end
    end
  end
end