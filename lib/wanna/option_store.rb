module Wanna
  class OptionStore

    class Boolean
      def validate(option, value)
        case value
        when /^(off|no|false)$/i, false, nil 
          false
        when /^(on|yes|true)$/i, true
          true
        else
          fail "Invalid boolean value `#{value}' for option `#{option}'"
        end
      end
    end
    
    class OneOf
      def initialize(*allowed)
        @allowed = allowed
      end
      def validate(option, value)
        value = value.intern unless value.kind_of?(Symbol)
        unless @allowed.include?(value)
          fail "The `#{option}' option can only take one of the values #{@allowed.join(', ')}. (I got `#{value}')"
        end
        value
      end
    end

    VALID_OPTIONS = {
      :tracing       => OneOf.new(*Wanna::Log::LEVELS),
      :show_commands => Boolean.new
    } unless defined?(VALID_OPTIONS)


    
    def merge_in(opts)
      opts.each do |option, value|
        set_demands_file_option(option, value)
      end
    end 
           
    def set_default_option(option, value)
      set_option(@default_options, option, value)
    end
    
    def set_demands_file_option(option, value)
      set_option(@demands_file_options, option, value)
    end
    
    def set_command_line_option(option, value)
      set_option(@command_line_options, option, value)
    end    

    # Command line options trump demands file options, and both trump the defaults
    def [](option)
      case
        when @command_line_options.has_key?(option)
          @command_line_options[option]
        when @demands_file_options.has_key?(option)
          @demands_file_options[option]
        else
          @default_options[option]
        end
    end
    
    
    private
    
    def set_option(store, option, value)
      option = option.intern unless option.kind_of?(Symbol)
      store[option] = validate(option, value)
    end
    
    def validate(option, value)
      validator = VALID_OPTIONS[option]
      fail "Unknown option: #{option}" unless validator
      validator.validate(option, value)
    end 
    

    def initialize
      # The actual option stores.
      @default_options = {}
      @demands_file_options = {}
      @command_line_options = {}

      # Set the default options. We could just use a hash literal, but this
      # way we get parameter checking
      set_default_option(:tracing, :errors)
    end
    
    
  end
end