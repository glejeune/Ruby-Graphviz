class GraphViz
  class Types
    class GvDouble < Common
      def check(data)
        unless [Float, Fixnum].include?( data.class )
          raise ArgumentError, "Value `#{data}' not allowed for attribut with double type!"
        end
        
        return data
      end
    end
  end
end