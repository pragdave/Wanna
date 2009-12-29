# Load up all the .rb files in the helpers directory. They'll define constants
# in the Wanna::Helpers module

require *Dir.glob(File.expand_path("helpers/*.rb", File.dirname(__FILE__)))

module Wanna
  # We're included into TasklistBuilder to define the methods such as "sh" that
  # are used inside the individual tasks
  module Helpers
    
    include *constants.map {|module_name| const_get(module_name)}

  end
end