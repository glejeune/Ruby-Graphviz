$:.unshift( "lib" )
require "graphviz/constants"

require 'rake/clean'
require 'bundler'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/testtask'
require 'fileutils'
require 'json/pure'
require 'open-uri'
include FileUtils

Bundler::GemHelper.install_tasks

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
    rdoc.rdoc_files.add ['README.rdoc', 'AUTHORS', 'COPYING',
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
  t.test_files = FileList['test/test_*.rb']
end

namespace :gemcutter do
  PKG_NAME = "ruby-graphviz"
  PKG_VERS = Constants::RGV_VERSION
  PKG_FILES = %w(COPYING README.rdoc AUTHORS setup.rb Rakefile) +
   	      Dir.glob("{bin,examples,lib,test}/**/*")

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
