# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "graphviz/constants"

Gem::Specification.new do |s|
  s.name = "ruby-graphviz"
  s.version = Constants::RGV_VERSION
  s.platform = Gem::Platform::RUBY
  
  s.authors = ["Gregoire Lejeune"]
  s.summary = %q{Interface to the GraphViz graphing tool}
  s.email = %q{gregoire.lejeune@free.fr}
  s.homepage = %q{http://github.com/glejeune/Ruby-Graphviz}
  s.description = %q{Ruby/Graphviz provides an interface to layout and generate images of directed graphs in a variety of formats (PostScript, PNG, etc.) using GraphViz.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.rubyforge_project = 'ruby-asp'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "COPYING", "AUTHORS"]
  s.rdoc_options = ["--title", "Ruby/GraphViz", "--main", "README.rdoc"]
  s.post_install_message = %{
Since version 0.9.2, Ruby/GraphViz can use Open3.popen3 (or not)
On Windows, you can install 'win32-open3'

You need to install GraphViz (http://graphviz.org/) to use this Gem.

For more information about Ruby-Graphviz :
* Doc : http://rdoc.info/projects/glejeune/Ruby-Graphviz
* Sources : http://github.com/glejeune/Ruby-Graphviz
* NEW - Mailing List : http://groups.google.com/group/ruby-graphviz

/!\\ Version 0.9.12 introduce a new solution to connect edges to node ports
For more information, see http://github.com/glejeune/Ruby-Graphviz/issues/#issue/13
So if you use node ports, maybe you need to change your code.

/!\\ GraphViz::Node#name has been removed!

/!\\ :output and :file options have been removed!

/!\\ The html attribut has been removed!
You can use the label attribut, as dot do it : :label => '<<html/>>'

/!\\ Version 0.9.17 introduce GraphML (http://graphml.graphdrawing.org/) support and
graph theory !
  }
  
  # s.add_runtime_dependency("middleman", "~>2.0.0.3")
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'json_pure'
end
