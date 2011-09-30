class GraphViz
   class Types
      class GvBool < Common
         def check(data)
            # TODO
            return data
         end

         def output
            return @data.to_s.inspect.gsub( "\\\\", "\\" )
         end

         alias :to_gv :output
         alias :to_s :output

         def to_ruby
            @data.to_ruby
         end
      end
   end
end
