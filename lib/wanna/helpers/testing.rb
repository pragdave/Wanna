module Wanna
  module Helpers
    module Testing

      def run_tests(options = {})
        set_instance_variable_options(options, "run_tests",
          :pattern => "test/*.rb",
          :lib     => "lib"
        )
        
        test_files = Dir.glob(@pattern)
        fail "No test files match #{@pattern.inspect}" if test_files.empty?
        
        ruby "-e 'ARGV.each {|f| load f}'",
             " -I #{@lib}",
             test_files.map{|file_name| cmd_line_escape(file_name)}
        
      end
      
      def run_rcov(options = {})
        set_instance_variable_options(options, "rub_rcov",
          :pattern => "test/*.rb",
          :lib     => "lib",
          :include => nil,
          :exclude => nil
          
        )
        options = []
        
        options << "#{cmd_line_escape(@lib, '-I')}" unless @lib.nil?
        options << "#{cmd_line_escape(@exclude, '-x')}" unless @exclude.nil?
        options << "#{cmd_line_escape(@include, '-i')}" unless @include.nil?
        
        sh "rcov #{options.join(' ')} #{@pattern}"
      end
      
      def cmd_line_escape(names, flag=nil)
        if names.respond_to?(:each)
          result = [] 
          names.each do |name|
            result << escape_one_name(name, flag)
          end
          result.join(' ')
        else
          escape_one_name(names, flag)
        end
      end
      
      def escape_one_name(name, flag)
        name = case name
        when /[\s!:"]/
          "'#{name}'"
        when /'/
          "\"#{name}\""
        else
          name
        end
        if flag
          "#{flag} #{name}"
        else
          name
        end
      end
      
      def set_instance_variable_options(options, cmd_name, default_hash)
        fail "#{cmd_name} was expecting an options hash, and got a #{options.class}" unless options.kind_of? Hash
        result = default_hash.dup
        options.each do |option, value|
          if result.has_key?(option)
            result[option] = value
          else
            fail "Invalid option ':#{option} => #{value.inspect}' for #{cmd_name}()"
          end
        end
        result.each do |name, value|
          instance_variable_set("@#{name}", value)
        end
      end
      
    end
  end
end