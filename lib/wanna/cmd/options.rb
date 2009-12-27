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
        ['--option', '-O option=value', "Set the given option before parsing the demands",
          lambda do |opt|
            unless opt =~ /^(.*?)=(.*)/
              STDERR.puts "Invalid Wanna option: #{opt}"
              exit 1
            end
            option = $1
            value = $2
            begin
              Wanna::Options.set_command_line_option(option, value)
            rescue RuntimeError => e
              STDERR.puts e.message
              STDERR.puts "(for a list of valid options, try `wanna --help')"
              exit 1
            end
          end
        ],
      ].each {|option| op.on(*option) }
        
      op.parse!
    end
  end
end
