require "wanna/tasklist"
require "wanna/task"
require "wanna/task/basic"
require "wanna/task/file"
require "wanna/file_target"

module Wanna
  class TasklistBuilder
    
    def initialize
      @tasklist = Tasklist.new 
      @groups  = []
    end
    
    def interpret(&block)
      instance_eval(&block)
    end
    
    # Used to specify that a target is a file (or a file pattern)
    #
    #   to create("book.pdf") do..
    #
    #   to create(".xml"), :from => ".pml"
    #
    #   to create("big_<name>"), :from => "<name>"
    #
    def create(filespec)
      Wanna::FileTarget.new(filespec)
    end
    
    def to(task_descriptor, options = {}, &block) 
      klass = case task_descriptor
        when String           then Task::Basic
        when Wanna::FileTarget then Task::File
        else
          fail "The first parameter to a to() call should be a String. I got a #{task_descriptor.class}"
      end     
      task = klass.new(task_descriptor, options, block)
      @tasklist.add_task(task)
    end
    
    def run_target(target)
      run_target_internal(target, {})
    end
    
    def run_target_internal(target, already_run)
      return if already_run.has_key?(target)
      task = find_task(target)
      if task.out_of_date?(self)  
        task.needs.each do |need_name|
          run_target_internal(need_name, already_run)
        end
        task.execute unless already_run.has_key?(target)
        already_run[target] = 1
      end
    end
    
    def display_tasks_matching(pattern, io)
      @tasklist.tasks_matching(pattern).each do |task|
        io.puts task.display_name
      end
    end 
      
    def out_of_date?(task_name)
      find_task(task_name).out_of_date?(self)
    end
    
    
    def find_task(task_name)
      task = @tasklist.find_task(task_name)
      if task
        return task
      else
        STDERR.puts "Cannot find task '#{task_name}'"
        exit 1
      end
     end 
  end
end