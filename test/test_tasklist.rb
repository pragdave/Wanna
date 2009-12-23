require File.expand_path('test_helper', File.dirname(__FILE__))
require 'wanna/task/basic'
require 'wanna/tasklist'

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
      assert_equal [ @task ], @tasklist.tasks_matching("long")
    end

    should "return that task by matching its short name" do
      assert_equal [ @task ], @tasklist.tasks_matching("sh[aeiou]rt")
    end

    should "return no tasks if the match fails" do
      assert_equal [ ], @tasklist.tasks_matching("wibble")
    end
  end
end
