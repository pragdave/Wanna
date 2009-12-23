require "wanna/task"

module Wanna
  class Task
    
    class Basic < Wanna::Task
      
      def initialize(full_name, options, block)
        if full_name =~ /(.*)\s+\(aka\s+(.*)\)$/
          super($1, $2, options, block)
        else
          super(full_name, nil, options, block)
        end
      end
           
      # Basic tasks always run
      def out_of_date?(tasklist)
        true
      end
    end
  end
end

  