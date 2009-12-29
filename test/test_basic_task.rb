require File.expand_path('test_helper', File.dirname(__FILE__))

class TestBasicTask < Test::Unit::TestCase

  context "a new basic task" do
    setup do 
      @task = Wanna::Task::Basic.new("the long name (aka shortname)", {}, nil)
    end
   
    should "have a long name" do
      assert_equal "the long name", @task.name
    end
    
    should "have a short name" do
      assert_equal "shortname", @task.short_name
    end

    should "have a display name" do
      assert_equal "the long name (aka shortname)", @task.display_name
    end
        
    should "not have needs" do
      assert @task.needs.empty?
    end
    
    should "not use anything" do
      assert @task.uses.empty?
    end 
    
    should "be out of date" do
      assert @task.out_of_date?(nil)
    end
  end
  
  context "a basic task with no (aka ...) in the name" do
    setup do 
      @task = Wanna::Task::Basic.new("the long name", {}, nil)
    end
   
    should "have a long name" do
      assert_equal "the long name", @task.name
    end
    
    should "not have a short name" do
      assert_equal nil, @task.short_name
    end

    should "have a display name" do
      assert_equal "the long name", @task.display_name
    end
        
  end
end