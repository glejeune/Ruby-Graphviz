class GraphViz
  class Types
    class Color < Common
      TYPELIST = [
        /^(^0|^1|^){1}(\.[0.9]{1,3})?\s*[,]?\s*(0|1|){1}(\.[0.9]{1,3})?\s*[,]?\s*(0|1|){1}(\.[0.9]{1,3})?$/, # HSV
        /^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$/, # RGB or RGBA
        /^[a-z]+[0-9]*$/ # colorname
      ]
      def check(data)
        match = false
        TYPELIST.each do |e|
          match = not e.match(data).nil?
        end
        
        if match == false
          raise ArgumentError, "Value `#{data}' not allowed for attribut with color type!"
        end
        
        return data
      end
      
      def output
        return '"'+@data+'"'
      end
    end
  end
end