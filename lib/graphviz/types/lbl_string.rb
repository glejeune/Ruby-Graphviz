class GraphViz
  class Types
    class LblString < Common
      def check(data)
        return data
      end

      def output
        html = /^<([<|(^<)*<].*)>$/m.match(@data.to_s)
        if html != nil
          "<#{html[1]}>"
        else
          @data.to_s.inspect.gsub( "\\\\", "\\" )
        end
      end

      alias :to_gv :output
      alias :to_s :output
      alias :to_ruby :output
    end
  end
end
