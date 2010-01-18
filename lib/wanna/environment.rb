# We probably don't have the best name—We're responsible for loading up the
# overall environment for this run. We locate the demands file or directory. If a file,
# we read it in. If a directory, we read in all the demands, and we also read in the
# helpers and task definitions

module Wanna
  module Environment
     
    @demand_file_directory = Dir.pwd
    
    def self.load(options)
      @demand_file_name = options.demand_file_name
      location = find_demand_file(@demand_file_name)
      case
      when location && File.file?(location)
        File.read(location)
      when location && File.directory?(location)
        fail "don;t know what to do"
      else
        Wanna::Log.error("Cannot find file or directory #{@demand_file_name}")
        exit 1        
      end
    end

    # if the name contains any path characters, then it is assumed to be
    # the full path, otherwise we treat it as a name and look in the current 
    # directory, the parent, and so on
    def self.find_demand_file(name)
      if contains_path?(name)
        check_demand_file_in(name)
      else
        search_for_demand_file(@demand_file_directory, name)
      end
    end  
     
    def self.search_for_demand_file(dir, name)
      path = File.join(dir, name)
      if File.exist?(path)
        path
      else
        @demand_file_directory = File.dirname(dir)
        return nil if @demand_file_directory == dir
        search_for_demand_file(@demand_file_directory, name)
      end
    end
    
    def self.contains_path?(name)
      if mswin?
        name =~ %r{[:\\/]}
      else
        name =~ %r{/}
      end
    end

    # from Redmine
    def self.mswin?
      (RUBY_PLATFORM =~ /(:?mswin|mingw)/) || (RUBY_PLATFORM == 'java' && (ENV['OS'] || ENV['os']) =~ /windows/i)
    end
  end
end