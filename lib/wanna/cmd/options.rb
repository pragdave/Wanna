# encoding: utf-8

require 'optparse'
require 'wanna'

module Wanna::Cmd
  class Options
    
    attr_reader :display_task_pattern
    
    def initialize(tasklist_builder)
      @tasklist_builder = tasklist_builder
    end
    
    def parse
      op = OptionParser.new
      op.banner = "\nwanna <options> <targets...>\n\n"
      
      [
        ['--demands', '-f file-or-dir', "Read demands from the given file or directory (default 'Demands')",
          lambda do |filename|
            @tasklist_builder.demand_file_name = filename
          end
        ],
        ['--list-helpers', '-L', "Display the names of helper methods and exit.",
          lambda do |pattern|
            Wanna::Helpers.list(STDOUT)
            exit 0
          end
        ],
        ['--option', '-O option=value', "Set the given option before parsing the demands",
          lambda do |opt|
            set_wanna_option(opt)
          end
        ],
        ['--tasks', '-T [PATTERN]', "Display the tasks and exit.",
          lambda do |pattern|
            @display_task_pattern = pattern || '.'
          end
        ],
        ['--version', '-V', "Display the curent version and exit.",
          lambda do
            STDERR.puts "wanna #{Wanna::VERSION}"
            exit 0
          end
        ]
      ].each {|option| op.on(*option) }
        
      op.parse!
    end
    
    
    def set_wanna_option(opt)
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
  end
end
