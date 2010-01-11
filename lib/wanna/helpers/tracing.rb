module Wanna
  module Helpers
    module Tracing

      def say(*msg)
        Wanna::Log.info(*msg)
      end
      
      def error(*msg)
        Wanna::Log.error(*msg)
      end
      
    end
  end
end