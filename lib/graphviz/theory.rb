require 'graphviz/math/matrix'

class GraphViz
  class Theory
    def initialize( graph )
      @graph = graph
    end
    
    def adjancy_matrix
      matrix = GraphViz::Math::Matrix.new( @graph.node_count, @graph.node_count )
      
      @graph.each_edge { |e|
        x = @graph.get_node(e.node_one( false )).index
        y = @graph.get_node(e.node_two( false )).index
        matrix[x+1, y+1] = 1
        matrix[y+1, x+1] = 1 if @graph.type == "graph"
      }
      
      return matrix
    end
    
    def incidence_matrix
      tail = (@graph.type == "digraph") ? -1 : 1
      matrix = GraphViz::Math::Matrix.new( @graph.node_count, @graph.edge_count )
      
      @graph.each_edge { |e|
        x = e.index
        
        nstart = @graph.get_node(e.node_one( false )).index
        nend = @graph.get_node(e.node_two( false )).index
        
        matrix[nstart+1, x+1] = 1
        matrix[nend+1, x+1] = tail
        matrix[nend+1, x+1] = 2 if nstart == nend
      }
      
      return matrix
    end
    
    def degree( node )
      degree = 0
      name = node 
      if node.kind_of?(GraphViz::Node)
        name = node.id
      end
      
      @graph.each_edge do |e|
        degree += 1 if e.node_one(false) == name or e.node_two(false) == name
      end
      
      return degree
    end
    
    def degree_matrix
      matrix = GraphViz::Math::Matrix.new( @graph.node_count, @graph.node_count )
      @graph.each_node do |name, node|
        i = node.index
        matrix[i+1, i+1] = degree(node)
      end
      return matrix
    end
    
    def laplacian_matrix
      return degree_matrix - adjancy_matrix
    end
        
    def symmetric?
      adjancy_matrix == adjancy_matrix.transpose
    end

    #
    # more_dijkstra(source, destination)
    # 
    def moore_dijkstra( dep, arv )
      m = distance_matrix
      n = @graph.node_count
      # Table des sommets à choisir
      c = [dep.index]
      # Table des distances
      d = []
      d[dep.index] = 0
      
      # Table des predecesseurs
      pred = []
      
      @graph.each_node do |name, k|
        if k != dep
          d[k.index] = m[dep.index+1,k.index+1]
          pred[k.index] = dep
        end
      end
      
      while c.size < n
        # trouver y tel que d[y] = min{d[k];  k sommet tel que k n'appartient pas à c}
        mini = 1.0/0.0
        y = nil
        @graph.each_node do |name, k|
          next if c.include?(k.index)
          if d[k.index] < mini
            mini = d[k.index]
            y = k
          end
        end
        
        # si ce minimum est ∞ alors sortir de la boucle fin si
        break unless mini.to_f.infinite?.nil?
        
        c << y.index
        @graph.each_node do |name, k|
          next if c.include?(k.index)
          if d[k.index] > d[y.index] + m[y.index+1,k.index+1]
            d[k.index] = d[y.index] + m[y.index+1,k.index+1]
            pred[k.index] = y
          end
        end
      end
      
      # Construction du chemin le plus court
      ch = []
      k = arv
      while k.index != dep.index
        ch.unshift(k.id)
        k = pred[k.index]
      end
      ch.unshift(dep.id)
      
      if d[arv.index].to_f.infinite?
        return nil
      else
        return( { 
          :path => ch,
          :distance => d[arv.index]
        } )
      end
    end
    
    private 
    def distance_matrix
      type = @graph.type
      matrix = GraphViz::Math::Matrix.new( @graph.node_count, @graph.node_count, (1.0/0.0) )
      
      @graph.each_edge { |e|
        x = @graph.get_node(e.node_one( false )).index
        y = @graph.get_node(e.node_two( false )).index
        unless x == y
          weight = ((e[:weight].nil?) ? 1 : e[:weight].to_f)
          matrix[x+1, y+1] = weight
          matrix[y+1, x+1] = weight if type == "graph"
        end
      }
      
      return matrix
    end    
  end
end