$:.unshift( "lib" )
require "graphviz/constants"

require 'rake/clean'
require 'bundler'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/testtask'
require 'fileutils'
require 'open-uri'
include FileUtils

CLEAN.include ['**/.*.sw?', '*.gem', '.config', 'test/test.log']
RDOC_OPTS = ['--quiet', '--title', "Ruby/GraphViz, the Documentation",
    "--opname", "index.html",
    "--line-numbers",
    "--main", "README.rdoc"]

desc "Packages up Ruby/GraphViz."
task :default => [:test, :package]
task :package => [:clean]

task :doc => :rdoc

RDoc::Task.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.main = "README.rdoc"
    rdoc.title = "Ruby/GraphViz, the Documentation"
    rdoc.rdoc_files.add ['README.rdoc', 'CHANGELOG.rdoc', 'AUTHORS.rdoc', 'COPYING.rdoc',
      'lib/graphviz.rb', 
      'lib/graphviz/node.rb',
      'lib/graphviz/edge.rb',
      'lib/graphviz/constants.rb',
      'lib/graphviz/xml.rb',
      'lib/graphviz/graphml.rb',
      'lib/graphviz/family_tree.rb',
      'lib/graphviz/family_tree/couple.rb',
      'lib/graphviz/family_tree/generation.rb',
      'lib/graphviz/family_tree/person.rb',
      'lib/graphviz/family_tree/sibling.rb']
end

Rake::TestTask.new(:test) do |t|
  require 'graphviz/utils'
  include GVUtils
  if find_executable("dot", nil).nil?
    t.test_files = FileList['test/test_*.rb'].exclude("test/test_examples.rb") 
  else
    t.test_files = FileList['test/test_*.rb']
  end
end

Bundler::GemHelper.install_tasks

namespace :gemcutter do
  desc "check gemcutter status"
  task :status do
    if Rubygems.status
      puts "This gem already existe in version #{PKG_VERS}!"
    else
      puts "This gem (#{Constants::RGV_VERSION}) has not been published! Last version at gemcutter is #{Rubygems.version}"
    end
  end
end
