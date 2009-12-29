module Wanna
  class Tasklist

    def initialize
      @tasks = {}
      @tasks_by_group = {}
    end

    def add_task(task, group = [])
      add_task_by_name(task, task.name, group)
      add_task_by_name(task, task.short_name, group) if task.short_name
    end
    
    def find_task(name)
      @tasks[name]
    end                                      
    
    def tasks_matching(pattern = nil)
      pattern = Regexp.new(pattern || '.', Regexp::IGNORECASE)
      result = []
      @tasks_by_group.keys.sort.each do |group|
        tasks = @tasks_by_group[group]
        if group && group.any? { |g| g =~ pattern }
          result << [ group, tasks.values.uniq ]
        else
          matches = tasks.values.select {|task| task =~ pattern }.uniq.sort_by {|task| task.name}
          result << [ group, matches.uniq ] unless matches.empty?
        end
      end   
      result
    end
    
    # For testing
    def tasks_in_group(group_array)
      @tasks_by_group[group_array].values
    end
  private
    
    def add_task_by_name(task, name, group)
      fail "There is already a task called #{name.inspect}" if @tasks.has_key?(name)
      @tasks[name] = task
      
      (@tasks_by_group[group] ||= {})[name] = task
    end
    
  end
end