class GraphViz
  class Types
    class GvDouble < Common
      def check(data)
        return data
      end
      
      def output
        return @data.to_s.inspect.gsub( "\\\\", "\\" )
      end
      
      def to_f
        @data.to_f
      end
      
      alias :to_gv :output
      alias :to_s :output
    end
  end
end