class GraphViz
  class Types
    class DoubleList < Common
      def check(data)
        match = true
        data.split( ":" ).each do |double|
          begin
            GraphViz::Types::GvDouble.new(double)
          rescue ArgumentError
            match = false
            break;
          end
        end
        
        if match == false
          raise ArgumentError, "Value `#{data}' not allowed for attribut with doubleList type!"
        end
        
        return data
      end
      
      def output
        return '"'+@data+'"'
      end
    end
  end
end