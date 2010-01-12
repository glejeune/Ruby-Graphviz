class GraphViz
  class Types
    class GvInt < Common
      def check(data)
        unless data.class == Fixnum
          raise ArgumentError, "Value `#{data}' not allowed for attribut with int type!"
        end
        
        return data
      end
    end
  end
end