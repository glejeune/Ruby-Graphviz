// Copyright (C) 2010 Gregoire Lejeune <gregoire.lejeune@free.fr>
// 
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA

BEGIN {
	int g_strict; int g_direct;
	graph_t cluster;
	node_t cnode;
	edge_t cedge;
	string attr; string attrv;
	
	printf( "# This code was generated with dot2ruby.gv\n\n" );
}

BEG_G {
	printf( "require 'rubygems'\nrequire 'graphviz'\n");
	// Directed 
	g_direct = isDirect($);
	if( g_direct == 0 ) {
		printf( "g = GraphViz.graph( \"%s\"", $.name );
	} else {
		printf( "g = GraphViz.digraph( \"%s\"", $.name );
	}
  // Strict
	g_strict = isStrict($);
	if( g_strict != 0 ) {
		printf( ", :strict => true" );
	}
	printf( " ) { |g|\n");
	
	// Attributs of G
	attr = fstAttr($, "G");
	while( attr != "" ) {
		attrv = aget( $, attr );
		if( attrv != "" ) {
		  printf( "  g[:%s] = '%s'\n", attr, attrv );
		} else {
			printf( "  # ATTR %s USED!\n", attr );
		}
		attr = nxtAttr( $, "G", attr );
	}
	
	// TODO
	cluster = fstsubg($);
	while( cluster != NULL ) {
		// printf( "cluster : %s\n", cluster.name );
		cluster = nxtsubg(cluster);
	}
}

N {
	printf( "  node_%s = g.add_node( \"%s\"", $.name, $.name );

	// Attributs of N
	attr = fstAttr($G, "N");
	while( attr != "" ) {
		attrv = aget( $, attr );
		if( attrv != "" ) {
		  printf( ", :%s => '%s'", attr, attrv );
		} else {
			printf( ", :%s => ''", attr );
		}
		attr = nxtAttr( $G, "N", attr );
	}
	
	printf( " )\n");
}

E {
	printf( "  g.add_edge( \"%s\", \"%s\"", $.tail.name, $.head.name );
	
	// Attributs of E
	attr = fstAttr($G, "E");
	while( attr != "" ) {
		attrv = aget( $, attr );
		if( attrv != "" ) {
		  printf( ", :%s => '%s'", attr, attrv );
		} else {
			printf( ", :%s => ''", attr );
		}
		attr = nxtAttr( $G, "E", attr );
	}
	
	printf( " )\n" );
}

END_G {
	printf( "}\n" );
	printf( "puts g.output( :canon => String )");
}
