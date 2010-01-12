class GraphViz
  class Types
    class Pagedir < Common
      TYPELIST = ["BL", "BR", "TL", "TR", "RB", "RT", "LB", "LT"]
      def check(data)
        unless TYPELIST.include?(data)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with pagedir type!"
        end
        return data
      end
    end
  end
end