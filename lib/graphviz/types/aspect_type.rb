class GraphViz
  class Types
    class AspectType < Common
      TYPEREG = /^((^0|^[1-9]+[0-9]*|^)?\.)?([0-9]*)(,(0|[1-9]+[0-9]*))?$/
      
      def check(data)
        unless TYPEREG.match(data.to_s)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with aspectType type!"
        end
        return data.to_s
      end
      
      def output
        return '"'+@data+'"'
      end
    end
  end
end