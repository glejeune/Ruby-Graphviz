#!/bin/sh

echo "arrowhead.rb"
ruby arrowhead.rb $1
echo "HTML-Labels.rb"
ruby HTML-Labels.rb
echo "p2p.rb"
ruby p2p.rb $1

echo "sample01.rb"
ruby sample01.rb $1
echo "sample02.rb"
ruby sample02.rb $1
echo "sample03.rb"
ruby sample03.rb $1
echo "sample04.rb"
ruby sample04.rb $1
echo "sample05.rb"
ruby sample05.rb $1
echo "sample06.rb"
ruby sample06.rb                   
echo "sample07.rb"
ruby sample07.rb $1
echo "sample08.rb"
ruby sample08.rb $1
echo "sample09.rb"
ruby sample09.rb $1
echo "sample10.rb"
ruby sample10.rb $1
echo "sample11.rb"
ruby sample11.rb $1
echo "sample12.rb"
ruby sample12.rb $1
echo "sample13.rb"
ruby sample13.rb
echo "sample14.rb"
ruby sample14.rb
echo "sample15.rb"
ruby sample15.rb
echo "sample16.rb"
ruby sample16.rb
echo "sample17.rb"
ruby sample17.rb
echo "sample18.rb"
ruby sample18.rb
echo "sample19.rb"
ruby sample19.rb
echo "sample20.rb"
ruby sample20.rb
echo "sample21.rb"
ruby sample21.rb
echo "sample22.rb"
ruby sample22.rb
echo "sample23.rb"
ruby sample23.rb
echo "sample24.rb"
ruby sample24.rb
echo "sample25.rb"
ruby sample25.rb

echo "shapes.rb"
ruby shapes.rb $1
echo "testorder.rb"
ruby testorder.rb $1
echo "testxml.rb"
ruby testxml.rb $1

cd dot
pwd
echo "dot/hello_test.rb"
ruby hello_test.rb
cd ..

cd graphviz.org
echo "graphviz.org/cluster.rb"
ruby cluster.rb
echo "graphviz.org/hello_world.rb"
ruby hello_world.rb
echo "graphviz.org/lion_share.rb"
ruby lion_share.rb
echo "graphviz.org/process.rb"
ruby process.rb
echo "graphviz.org/TrafficLights.rb"
ruby TrafficLights.rb
cd ..