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
        return @data.inspect.gsub( "\\\\", "\\" )
      end
    end
  end
end