require "wanna/task"

module Wanna
  class Task
    
    class File < Wanna::Task
      
      def initialize(file_target, options, block)
        @file_target = file_target
        super(file_target.as_target_name, nil, options, block)
      end
      
      def out_of_date?(tasklist)
        return true unless @file_target.exist?                   
        
        # note the following is a recursive step
        return true if direct_ancestors.any? {|a| tasklist.out_of_date?(a) }
        
        # we now know that all our ancestors are file tasks and the files exist...
                                                               
        modified = @file_target.modified
        return true if direct_ancestors.any? {|a| tasklist.find_task(a).modified > modified }
        false
      end
      
      def modified
        @file_target.modified
      end     
    end
  end
end

