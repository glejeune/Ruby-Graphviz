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
    "--main", "README.rdoc",
    "--inline-source"]

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
      'lib/graphviz/xml.rb']
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
      s.homepage = %q{http://raa.ruby-lang.org/project/ruby-graphviz/}
      s.description = %q{Ruby/Graphviz provides an interface to layout and generate images of directed graphs in a variety of formats (PostScript, PNG, etc.) using GraphViz.}

      s.files = PKG_FILES
      s.require_path = "lib"
      s.bindir = "bin"
      s.executables = ['ruby2gv', 'gem2gv']
      
      s.add_dependency('treetop')

      s.rubyforge_project = 'ruby-asp'
      s.has_rdoc = true
      s.extra_rdoc_files = ["README.rdoc", "COPYING", "AUTHORS"]
      s.rdoc_options = ["--title", "Ruby/GraphViz", "--main", "README.rdoc", "--line-numbers"]
      
      s.post_install_message = %{
Since version 0.9.2, Ruby/GraphViz can use Open3.popen3 (or not)
On Windows, you can install 'win32-open3'

You need to install GraphViz (http://graphviz.org/) to use this Gem.

}
    end

Rake::GemPackageTask.new(spec) do |p|
    p.need_tar = true
    p.gem_spec = spec
end

# desc "Create Windows Gem"
# task :win32_gem do
#   # WinSpecs
#   win_spec = spec.clone
#   win_spec.add_dependency('win32-open3')
#   win_spec.platform = 'mswin32'
# 
#   # Create the gem, then move it to pkg.
#   Gem::Builder.new(win_spec).build
#   gem_file = "#{win_spec.name}-#{win_spec.version}-#{win_spec.platform}.gem"
#   mv(gem_file, "pkg/#{gem_file}")
# end

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
  desc "push to gemcutter"
  task :push => [:package] do
    unless Rubygems.status
      sh %{gem push pkg/#{PKG_NAME}-#{PKG_VERS}.gem}, :verbose => true
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
