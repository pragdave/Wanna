module Wanna
  module Log
    
    LEVEL_MAP = { :silent => 0, :errors => 1, :information => 2, :verbose => 3 } unless defined?(LEVEL_MAP)
    
    LEVELS = LEVEL_MAP.to_a.sort_by {|_, level| level}.map {|name, _| name } unless defined?(LEVELS)
                  
    # These are ansi colors
    COLOR_MAP = { :errors => 1, :information => 2, :verbose => 4, :command => 6 } unless defined?(COLOR_MAP)
                  
    def self.info(msg)
      maybe_log(:information, msg)
    end
    
    def self.error(msg)
      STDERR.puts
      maybe_log(:errors, "*** #{msg}")
    end
    
    def self.maybe_log(level, msg)
      if LEVEL_MAP[Wanna::Options[:tracing]] >= LEVEL_MAP[level]
        log_with_timestamp(level, msg)
      end
    end
    
    def self.log_with_timestamp(color, msg)
      STDERR.puts Time.now.strftime("%H:%M:%S: #{colorize(color, msg)}")
    end

  private
    def self.colorize(color, msg)
      if Wanna::Options[:colorize]
        "\033[3#{COLOR_MAP[color]}m#{msg}\033[39m"
      else
        msg
      end
    end
  end
end