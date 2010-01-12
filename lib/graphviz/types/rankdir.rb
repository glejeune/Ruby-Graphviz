class GraphViz
  class Types
    class Rankdir < Common
      TYPELIST = ["TB", "LR", "BT", "RL"]
      def check(data)
        unless TYPELIST.include?(data)
          raise ArgumentError, "Value `#{data}' not allowed for attribut with rankdir type!"
        end
        return data
      end
    end
  end
end