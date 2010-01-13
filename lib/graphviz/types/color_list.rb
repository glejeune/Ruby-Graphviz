class GraphViz
  class Types
    class ColorList < Common
      def check(data)
        match = true
        data.split( ":" ).each do |color|
          begin
            GraphViz::Types::Color.new(color)
          rescue ArgumentError
            match = false
            break;
          end
        end
        
        if match == false
          raise ArgumentError, "Value `#{data}' not allowed for attribut with colorList type!"
        end
        
        return data
      end
      
      def output
        return '"'+@data+'"'
      end
    end
  end
end