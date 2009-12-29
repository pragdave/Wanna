require File.expand_path('test_helper', File.dirname(__FILE__))

class TestTasklist < Test::Unit::TestCase

  context "a tasklist with one basic task" do
    setup do 
      @tasklist = Wanna::Tasklist.new
      @task = Wanna::Task::Basic.new("long name (aka shortname)", {}, nil)
      @tasklist.add_task(@task)
    end
    
    should "be able to find it using the long name" do
      assert_equal @task, @tasklist.find_task("long name")
    end

    should "be able to find it using the short name" do
      assert_equal @task, @tasklist.find_task("shortname")
    end
    
    should "fail to add another task of the name name" do
      assert_raise(RuntimeError) do
        @tasklist.add_task(@task.dup)
      end
    end
    
    should "return that task by matching its name" do
      results = @tasklist.tasks_matching("long")
      assert_equal 1, results.size
      group, tasks = results.first
      assert_equal [ @task ], tasks
    end

    should "return that task by matching its short name" do
      results = @tasklist.tasks_matching("sh[aeiou]rt")
      assert_equal 1, results.size
      group, tasks = results.first
      assert_equal [ @task ], tasks
    end

    should "return no tasks if the match fails" do
      assert_equal [ ], @tasklist.tasks_matching("wibble")
    end
  end
  
  context "A tasklist with groups" do
    setup do
      @tasklist = Wanna::Tasklist.new
      @task1 = Wanna::Task::Basic.new("task 1", {}, nil)
      @task2 = Wanna::Task::Basic.new("task 2", {}, nil)
      @task3 = Wanna::Task::Basic.new("task 3", {}, nil)
      @task4 = Wanna::Task::Basic.new("task 4", {}, nil)
      @tasklist.add_task(@task1)  # not in a group
      @tasklist.add_task(@task2, [ "group1" ])
      @tasklist.add_task(@task3, [ "group1" ])
      @tasklist.add_task(@task4, [ "group2" ])
    end
    
    should "return tasks matching the task name" do
      result = @tasklist.tasks_matching("task 1")
      assert_equal 1, result.size
      group, tasks = result.first
      assert_equal [], group
      assert_equal [ @task1 ], tasks
    end  
    
    should "return tasks matching the group's name" do
      result = @tasklist.tasks_matching("group1")
      assert_equal 1, result.size
      group, tasks = result.first
      assert_equal [ "group1" ], group
      assert_equal [ @task2, @task3 ], tasks
    end
    
  end
end
