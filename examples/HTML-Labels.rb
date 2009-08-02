$:.unshift( "../lib" );
require "graphviz"

g = GraphViz::new( "structs", :output => "png" )

g.node["shape"] = "plaintext"

g.add_node( "HTML" )

g.add_node( "struct1", "html" => '<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">  <TR><TD>left</TD><TD PORT="f1">mid dle</TD><TD PORT="f2">right</TD></TR> </TABLE>>]; struct2 [label=< <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">  <TR><TD PORT="f0">one</TD><TD>two</TD></TR> </TABLE>')

g.add_node( "struct2", "html" => '<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">  <TR><TD PORT="f0">one</TD><TD>two</TD></TR> </TABLE>' )
g.add_node( "struct3", "html" => '<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="4">  <TR>  <TD ROWSPAN="3">hello<BR/>world</TD>  <TD COLSPAN="3">b</TD>  <TD ROWSPAN="3">g</TD>  <TD ROWSPAN="3">h</TD>  </TR>  <TR>  <TD>c</TD><TD PORT="here">d</TD><TD>e</TD>  </TR>  <TR>  <TD COLSPAN="3">f</TD>  </TR> </TABLE>' )

g.add_edge( "struct1:f1", "struct2:f0" )
g.add_edge( "struct1:f2", "struct3:here" )

g.add_edge( "HTML", "struct1" )

g.output( :path => '/usr/local/bin/', :file => "#{$0}.png" )
