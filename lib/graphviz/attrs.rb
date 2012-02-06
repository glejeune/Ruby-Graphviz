# Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2010 Gregoire Lejeune <gregoire.lejeune@free.fr>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA

class AttributeException < RuntimeError
end

class GraphViz
   class Attrs
      attr_accessor :data

      def initialize( gviz, name, attributes )
         @name       = name
         @attributes = attributes
         @data       = Hash::new( )
         @graphviz   = gviz
      end

      def each
         @data.each do |k, v|
            yield(k, v)
         end
      end

      def to_h
         @data.clone
      end

      def []( key )
         if key.class == Hash
            key.each do |k, v|
               self[k] = v
            end
         else
            if @data.key?( key.to_s ) == false
               nil
            end
            @data[key.to_s]
         end
      end

      def []=( key, value )
         unless @attributes.keys.include?( key.to_s )
            raise ArgumentError, "#{@name} attribute '#{key.to_s}' invalid"
         end

         if value.nil?
            warn "Value for attribute `#{key}` can't be null"
            return
         end

         begin
            value = GraphViz::Types.const_get(@attributes[key.to_s]).new( value )
         rescue => e
            raise AttributeException, "Invalide value `#{value}` for attribute `#{key}` : #{e}"
         end
         unless value.nil?
            @data[key.to_s] = value

            if @graphviz.nil? == false
               @graphviz.set_position( @name, key.to_s, @data[key.to_s] )
            end
         end
      end
   end
end
