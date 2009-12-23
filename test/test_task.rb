require File.expand_path('test_helper', File.dirname(__FILE__))
require 'wanna/task'

class TestTask < Test::Unit::TestCase

  context "a new task" do
    setup do 
      @task = Wanna::Task.new
    end
   
    should "not have a name" do
      assert @task.name.nil?
    end
    
    should "not have a short name" do
      assert @task.short_name.nil?
    end
    
    should "not have needs" do
      assert @task.needs.empty?
    end
    
    should "not use anything" do
      assert @task.uses.empty?
    end
  end 
  
  context "a task with a bad option" do
    should "fail with an exception" do
      assert_raises(RuntimeError) do
        Wanna::Task.new("a", "b", :bad => 1)
      end
    end
  end
  
  context "a new task with a name but no short name" do
    setup do 
      @task = Wanna::Task.new("name")
    end
    
    should "have a name" do
      assert_equal "name", @task.name
    end

    should "not have a short name" do
      assert @task.short_name.nil?
    end  
    
    should "have a display name of just the name" do
      assert_equal "name", @task.display_name
    end
  end

  context "a new task with a name and a short name" do
    setup do 
      @task = Wanna::Task.new("name", "short")
    end
    
    should "have a name" do
      assert_equal "name", @task.name
    end

    should "have a short name" do
      assert_equal "short", @task.short_name
    end

    should "have a display name of the name and the short name" do
      assert_equal "name (aka short)", @task.display_name
    end
  end 
  
  context "a task with a block" do
    setup do
      @task = Wanna::Task.new("name", "short", {}, lambda { @ran = "yes" })
    end
    
    should "execute the block when execute is called" do
      @ran = "no"
      @task.execute
      assert_equal "yes", @ran
    end
  end
  
  context "task options" do
    should "be a hash" do
      assert_raises(RuntimeError) do
        Wanna::Task.new("t1", "t1s", "wibble")
      end
    end
  end
  
  context "a task that needs another" do
    setup do
      @t1 = Wanna::Task.new("t1", "t1s")
      @t2 = Wanna::Task.new("t2", "t2s", :needs => "t1")
    end
    
    should "report that task as a need" do
      assert_equal [ "t1" ], @t2.needs
    end 
    
    should "report that task as a direct ancestor" do
      assert_equal [ "t1" ], @t2.direct_ancestors
    end 
    
    should "not report the need the other way around" do
      assert_equal [], @t1.needs
    end
  end

  context "a task that uses another" do
    setup do
      @t1 = Wanna::Task.new("t1", "t1s")
      @t2 = Wanna::Task.new("t2", "t2s", :uses => "t1")
    end
    
    should "report that task as a used task" do
      assert_equal [ "t1" ], @t2.uses
    end 
    
    should "report that task as a direct ancestor" do
      assert_equal [ "t1" ], @t2.direct_ancestors
    end 
    
    should "not report the need the other way around" do
      assert_equal [], @t1.uses
    end
  end
end