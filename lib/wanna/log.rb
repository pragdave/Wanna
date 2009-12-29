module Wanna
  module Log
    
    LEVEL_MAP = { :silent => 0, :errors => 1, :information => 2, :verbose => 3 } unless defined?(LEVEL_MAP)
    
    LEVELS = LEVEL_MAP.to_a.sort_by {|_, level| level}.map {|name, _| name } unless defined?(LEVELS)
    
    def self.info(msg)
      self.log_with_timestamp(:information, msg)
    end
    
    def self.error(msg)
      self.log_with_timestamp(:errors, msg)
    end
    
    def self.log_with_timestamp(level, msg)
      if LEVEL_MAP[Wanna::Options[:tracing]] >= LEVEL_MAP[level]
        STDERR.puts Time.now.strftime("%H:%M:%S: #{msg}")
      end
    end
  end
end