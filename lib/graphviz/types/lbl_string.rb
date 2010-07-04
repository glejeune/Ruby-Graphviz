require 'nokogiri'

class GraphViz
  class Types
    class LblString < Common
      def check(data)
        return data
      end
      
      def output
        html = /^<(<.*>)>$/m.match(@data)
        if html != nil and Nokogiri::XML(html[1]).errors.size == 0  
          @data
        else
          @data.to_s.inspect.gsub( "\\\\", "\\" )
        end
      end
      
      alias :to_gv :output
      alias :to_s :output
    end
  end
end