class GraphViz
  class Types
    class Bool < Common
      TYPELIST = {
        /^0{1}$|^false$|^no$/i => false,
        /^[1-9]+[0-9]*$|^true$|^yes$/i => true
      }
      def check(data)
        value = nil
        TYPELIST.each do |e, v|
          if r = e.match(data)
            value = v
          end
        end
        
        if value.nil?
          raise ArgumentError, "Value `#{data}' not allowed for attribut with bool type!"
        end
        
        return data
      end
    end
  end
end