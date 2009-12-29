module Wanna
  module Helpers
    module CommandExecution
   
      def sh(cmd, *args)
        if Wanna::Options[:show_commands]
          Wanna::Log.log_with_timestamp(:command, "sh #{cmd}")
        end
        unless system(cmd)
          report_failure(cmd, args)
        end
      end
           
      def report_failure(cmd, args)
        Wanna::Log.error("Command failed: #{cmd}")
        exit 1
      end
    end
  end
end