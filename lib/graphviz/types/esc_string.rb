# >> x = "hello\n\t\\l\"world\""
# => "hello\n\t\\l\"world\""
# >> puts x.inspect.gsub( "\\\\", "\\" )
# "hello\n\t\l\"world\""
#
# OR
# 
# >> x = 'hello\n\t\l"world"'
# => "hello\\n\\t\\l\"world\""
# >> puts x.inspect.gsub( "\\\\", "\\" )
# "hello\n\t\l\"world\""


class GraphViz
  class Types
    class EscString < Common
      def check(data)
        return data
      end
      
      def output
        return @data.to_s.inspect.gsub( "\\\\", "\\" )
      end
      
      alias :to_gv :output
      alias :to_s :output
    end
  end
end