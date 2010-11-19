require 'rubygems'
require 'test/unit'
begin
require 'ruby-debug'
rescue LoadError
end
require 'stringio'

root = File.expand_path('../../lib',__FILE__)
$:.unshift(root) unless $:.include?(root)

require 'graphviz'

# hack so that the example scripts don't unnecessarily unshift @todo
class << $:
  def unshift path
    include?(path) ? self : super    # super will return self, too
  end
end

module TestSupport
  extend self

  # @todo move to app?
  def windows?
    /mswin|mingw/ =~ RUBY_PLATFORM
  end

  def dev_null
    windows? ? 'NUL' : '/dev/null'
  end
end

module IoHack

  #
  # this is a ridiculous hack to capture what was written to $stdout/$stderr for testing
  # an alternative is to use Open3.popen3 on external calls which has overhead
  # and OS dependencies.
  #
  # This hack would apparently not be as bad on 1.9, which would allow you to simply
  # set $stdout and $stderr to instances of StringIO
  #
  # I don't know what is the 'right way' to test this kind of thing
  #

  class IoHackStream < File
    #
    # pre 1.9 you can't assign $stdout and $stderr to anything other than
    # an IO::File instance.  what we *want* is to have them be StringIOs that
    # we can read from like strings for testing.  So this is a crazy proxy
    # around StringIO.    Note it makes *all* methods except a few protected,
    # which for me was failing silently when i forgot to make the appropriate
    # ones public.  hack!
    #

    except = %w(inspect kind_of?)
    except += except.map{|x| x.to_sym } # for Ruby 1.9
    these = ancestors[0].instance_methods
    # these = [1,2,3].map{|x| ancestors[x].instance_methods(false)}.flatten
    eraseme = (these - except)
    eraseme.each{ |name| protected name }
    attr_reader :io
    def initialize()
      @io = StringIO.new
      super(TestSupport.dev_null, 'r+') # probably doesn't matter the mode
    end
    these = %w(write << puts)
    these.each do |name|
      define_method(name) do |*a|
        @io.send(name, *a)
      end
    end
  end

  def fake_popen2 path
    push_io
    require path  # caller assumes responsibility for exceptions vis-a-vis stack
    pop_io
  end

  def io_stack
    @io_stack ||= []
  end

  def push_io
    io_stack.push [$stdout, $stderr]
    $stdout = IoHackStream.new
    $stderr = IoHackStream.new
    nil
  end

  def pop_io
    fail('stack empty') unless io_stack.any?
    result = [$stdout, $stderr]
    $stdout, $stderr = io_stack.pop
    result.each_with_index do |io,idx|
      if io.kind_of? IoHackStream
        io.io.seek(0)
        result[idx] = io.io.read
      end
    end
    result
  end
end
