# Load up all the .rb files in the helpers directory. They'll define constants
# in the Wanna::Helpers module


module Wanna
  # We're included into TasklistBuilder to define the methods such as "sh" that
  # are used inside the individual tasks
  module Helpers
   
   LIST_BY_MODULE = {} unless defined?(LIST_BY_MODULE)
   
   def self.for(description, &block)
      fail "missing helper block for #{description}" unless block
      mod = Module.new(&block)
      LIST_BY_MODULE[description] = mod.instance_methods.sort
      include mod
   end
   
   def self.list(io)
     LIST_BY_MODULE.keys.sort.each do |description|
       io.puts description
       methods = LIST_BY_MODULE[description]
       io.puts "    #{methods.join(', ')}"
     end
   end
  end
end     

%w{ command_execution testing tracing }.each do |helper_file|
  require File.expand_path("helpers/#{helper_file}.rb", File.dirname(__FILE__))
end
