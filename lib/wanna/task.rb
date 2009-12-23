require 'wanna/log'

module Wanna
  class Task
       
    attr_reader :name, :short_name, :needs, :uses
    
    attr_reader :block
    
    def initialize(name = nil, short_name = nil, options = nil, block = nil)
      @name       = name
      @short_name = short_name
      @block      = block
      @needs      = []
      @uses       = [] 
      parse_task_options(options) if options
    end 
    
    def execute
      Wanna::Log.info("#{@name}")
      block.call
    end 
    
    def display_name
      result = @name
      if @short_name
        result = result + " (aka #{@short_name})"
      end
      result
    end
    
    def =~(pattern)
      pattern =~ @name || (@short_name && pattern =~ @short_name)
    end
    
    def direct_ancestors
      needs + uses
    end
      
  private
  
    def parse_task_options(options)
      unless options.kind_of?(Hash)
        fail "Task #{display_name} options should be a hash (I see #{options.class})"
      end
      
      options.each do |option, value|
        case option.to_s
        when "needs"
          concat(@needs, value)
        when "uses"
          concat(@uses, value)
        else
          fail "Unknown option #{option} for task #{display_name}"
        end        
      end
    end
      
    # 1.9 no longer has String#to_a
    def concat(array, value)
      value = [ value ] unless value.kind_of?(Array)
      array.concat value
    end
  end
end