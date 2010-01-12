class GraphViz
  class Types
    class GvString < Common
      def check(data)
        unless data.class == String
          raise ArgumentError, "Value `#{data}' not allowed for attribut with string type!"
        end
        
        return data
      end
      
      def output
        return '"'+@data.gsub('"', '\\"').gsub("\n", '\\\\n').gsub("\\", "\\\\")+'"'
      end
    end
  end
end