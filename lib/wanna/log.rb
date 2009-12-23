module Wanna
  module Log
    
    def self.info(msg)
      self.log_with_timestamp(msg)
    end
    
    def self.log_with_timestamp(msg)
      STDERR.puts Time.now.strftime("%H:%M:%S: #{msg}")
    end
  end
end