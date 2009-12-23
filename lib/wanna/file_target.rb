module Wanna

  class FileTarget
    def initialize(name)
      @name = name
    end
    
    def as_target_name
      @name
    end 
    
    def exist?
      File.exist?(@name)
    end
    
    def modified
      File.mtime(@name)
    end
  end
  
end