# Load up all the .rb files in the helpers directory. They'll define constants
# in the Wanna::Helpers module

%w{ command_execution testing tracing }.each do |helper_file|
  require File.expand_path("helpers/#{helper_file}.rb", File.dirname(__FILE__))
end

module Wanna
  # We're included into TasklistBuilder to define the methods such as "sh" that
  # are used inside the individual tasks
  module Helpers
    
    include *constants.map {|module_name| const_get(module_name) }.select {|mod| mod.kind_of? Module }

  end
end