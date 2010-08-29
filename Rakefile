$:.unshift( "lib" )
require "graphviz/constants"

require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'
require 'json/pure'
require 'open-uri'
include FileUtils

PKG_NAME = "ruby-graphviz"
PKG_VERS = Constants::RGV_VERSION
PKG_FILES = %w(COPYING README.rdoc AUTHORS setup.rb) +
 	      Dir.glob("{bin,examples,lib,test}/**/*")

CLEAN.include ['**/.*.sw?', '*.gem', '.config', 'test/test.log']
RDOC_OPTS = ['--quiet', '--title', "Ruby/GraphViz, the Documentation",
    "--opname", "index.html",
    "--line-numbers",
    "--main", "README.rdoc"]

desc "Packages up Ruby/GraphViz."
task :default => [:test, :package]
task :package => [:clean]

task :doc => [:rdoc, :after_doc]

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.main = "README.rdoc"
    rdoc.title = "Ruby/GraphViz, the Documentation"
    rdoc.rdoc_files.add ['README.rdoc', 'AUTHORS', 'COPYING',
      'lib/graphviz.rb', 
      'lib/graphviz/node.rb',
      'lib/graphviz/edge.rb',
      'lib/graphviz/constants.rb',
      'lib/graphviz/xml.rb',
      'lib/graphviz/family_tree.rb',
      'lib/graphviz/family_tree/couple.rb',
      'lib/graphviz/family_tree/generation.rb',
      'lib/graphviz/family_tree/person.rb',
      'lib/graphviz/family_tree/sibling.rb']
end

task :after_doc do
    sh %{scp -r doc/rdoc/* #{ENV['USER']}@rubyforge.org:/var/www/gforge-projects/ruby-asp/ruby-graphviz}
end

spec =
    Gem::Specification.new do |s|
      s.name = PKG_NAME
      s.version = PKG_VERS
      s.platform = Gem::Platform::RUBY
      
      s.authors = ["Gregoire Lejeune"]
      s.summary = %q{Interface to the GraphViz graphing tool}
      s.email = %q{gregoire.lejeune@free.fr}
      s.homepage = %q{http://github.com/glejeune/Ruby-Graphviz}
      s.description = %q{Ruby/Graphviz provides an interface to layout and generate images of directed graphs in a variety of formats (PostScript, PNG, etc.) using GraphViz.}

      s.files = PKG_FILES
      s.require_path = "lib"
      s.bindir = "bin"
      s.executables = ['ruby2gv', 'gem2gv', 'dot2ruby', 'git2gv', 'xml2gv']
      
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

/!\\ GraphViz::Node#name is deprecated and will be removed in version 1.0.0

/!\\ :output and :file options are deprecated and will be removed in version 1.0.0

/!\\ The html attribut is deprecated and will be removed in version 1.0.0
You can use the label attribut, as dot do it : :label => '<<html/>>'

/!\\ Version 0.9.17 introduce GraphML (http://graphml.graphdrawing.org/) support and
graph theory !
}
    end

Rake::GemPackageTask.new(spec) do |p|
    p.need_tar = true
    p.gem_spec = spec
end

task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{PKG_NAME}-#{PKG_VERS}}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{PKG_NAME}}
end

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/test_*.rb']
#  t.warning = true
#  t.verbose = true
end

class Rubygems
  def initialize
    url = "http://rubygems.org/api/v1/gems/#{PKG_NAME}.json"
    @version_at_rubygems = JSON.parse( open(url).read )["version"]
  end
  
  def status
    version == PKG_VERS
  end
  def self.status
    self.new.status
  end
  
  def version
    @version_at_rubygems
  end
  def self.version
    self.new.version
  end
end

namespace :gemcutter do
  desc "push to gemcutter and tag for github"
  task :push => [:package] do
    unless Rubygems.status
      sh %{gem push pkg/#{PKG_NAME}-#{PKG_VERS}.gem}, :verbose => true
      begin
        sh %{git commit -am "Tag #{PKG_VERS}"}, :verbose => true
      rescue => e
        puts "Nothing to commit !"
      end
      sh %{git tag #{PKG_VERS}}, :verbose => true
      sh %{git push origin master --tags}
    else
      puts "This gem already existe in version #{PKG_VERS}!"
    end
  end
  
  desc "check gemcutter status"
  task :status do
    if Rubygems.status
      puts "This gem already existe in version #{PKG_VERS}!"
    else
      puts "This gem (#{PKG_VERS}) has not been published! Last version at gemcutter is #{Rubygems.version}"
    end
  end
end
