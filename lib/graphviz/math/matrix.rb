class GraphViz
  class Math
    class CoordinateError < RuntimeError
    end
    
    class Matrix
      def initialize( x, y, val = 0 )
        @matrix = Array.new(x)
        @matrix.size.times do |col|
          @matrix[col] = Array.new(y)
          @matrix[col].size.times do |line|
            @matrix[col][line] = val
          end
        end
        @x = x
        @y = y
      end
            
      def [](x, y)
        unless (0...@x).to_a.include?(x-1)
          raise CoordinateError, "Line out of range (#{x} for 1..#{@x})!"
        end
        unless (0...@y).to_a.include?(y-1)
          raise CoordinateError, "Column out of range (#{y} for 1..#{@y})!"
        end
        @matrix[x-1][y-1]
      end
      
      def []=( x, y, val )
        unless (0...@x).to_a.include?(x-1)
          raise CoordinateError, "Line out of range (#{x} for 1..#{@x})!"
        end
        unless (0...@y).to_a.include?(y-1)
          raise CoordinateError, "Column out of range (#{y} for 1..#{@y})!"
        end
        @matrix[x-1][y-1] = val
      end
      
      def matrix
        @matrix
      end
      alias :to_a :matrix
      
      def to_s
        size = bigger
        out = ""
        @x.times do |x|
          out << "["
          @y.times do |y|
            out << sprintf(" %1$*2$s", @matrix[x][y].to_s, size)
          end
          out << "]\n"
        end
        return out
      end
      
      def -(m)
        matrix = GraphViz::Math::Matrix.new( @x, @y )
        @x.times do |x|
          @y.times do |y|
            matrix[x+1, y+1] = self[x+1, y+1] - m[x+1, y+1]
          end
        end
        return matrix
      end
      
      def *(m)
        matrix = GraphViz::Math::Matrix.new( @x, @x )
        
        @x.times do |x|
          @x.times do |y|
            l = self.line(x+1)
            c = m.column(y+1)
            v = 0
            l.size.times do |i|
              v += l[i]*c[i]
            end
            matrix[x+1,y+1] = v
          end
        end
        
        return matrix
      end
      
      def line( x )
        unless (0...@x).to_a.include?(x-1)
          raise CoordinateError, "Line out of range (#{x} for 1..#{@x})!"
        end
        @matrix[x-1]
      end
      
      def column( y )
        col = []
        unless (0...@y).to_a.include?(y-1)
          raise CoordinateError, "Column out of range (#{y} for 1..#{@y})!"
        end
        @x.times do |x|
          col << self[x+1, y]
        end
        
        return col
      end
      
      def transpose
        matrix = GraphViz::Math::Matrix.new( @y, @x )
        @x.times do |x|
          @y.times do |y|
            matrix[y+1, x+1] = self[x+1, y+1]
          end
        end
        return matrix
      end
      
      def ==(m)
        equal = true
        @x.times do |x|
          @y.times do |y|
            equal &&= (m[x+1, y+1] == self[x+1, y+1])
          end
        end
        return equal
      end
      
      private
      def bigger
        b = 0
        @matrix.each do |x|
          x.each do |y|
            b = y.to_s.size if y.to_s.size > b
          end
        end
        return b
      end
    end
  end
end

puts "DEBUG GraphViz::Math::Matrix"
m = GraphViz::Math::Matrix.new( 2, 3 )
m[1,1] = 1; m[1,2] = 2; m[1,3] = 3
m[2,1] = 4; m[2,2] = 5; m[2,3] = 6
puts "m :"
puts m
puts

n = GraphViz::Math::Matrix.new( 3, 2 )
n[1,1] = 1; n[1,2] = 2
n[2,1] = 3; n[2,2] = 4
n[3,1] = 5; n[3,2] = 6
puts "n :"
puts n
puts

puts "m * n :"
puts m*n
puts
puts "n * m :"
puts n*m

puts "end DEBUG GraphViz::Math::Matrix"