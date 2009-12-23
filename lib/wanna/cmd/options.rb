# encoding: utf-8

require 'optparse'
require 'wanna'

module Wanna::Cmd
  class Options
    
    def initialize(tasklist_builder)
      @tasklist_builder = tasklist_builder
    end
    
    def parse
      op = OptionParser.new
      op.banner = "wanna <options> <targets...>"
      op.separator ""
      op.separator "Options are…"
      
      [
        ['--tasks', '-T [PATTERN]', "Display the tasks and exit.",
          lambda do |pattern|
            @tasklist_builder.display_tasks_matching(pattern, STDOUT)
            exit 0
          end
        ],
      ].each {|option| op.on(*option) }
        
      op.parse!
    end
  end
end
