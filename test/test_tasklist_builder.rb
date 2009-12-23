require File.expand_path('test_helper', File.dirname(__FILE__))
require 'wanna/tasklist_builder'
require 'mocha'

class TestTasklistBuilder < Test::Unit::TestCase

  context "a new TasklistBuilder" do
    setup do 
      @tlb = Wanna::TasklistBuilder.new
      @io = "dummy"
    end
    
    should "not have any tasks" do
      @io.expects(:puts).never
      @tlb.display_tasks_matching("xxx", @io)
    end
    
    should "add a basic task when a string is passed to to()" do
      @tlb.to("basic task (aka simple)")
      @io.expects(:puts).with("basic task (aka simple)")
      @tlb.display_tasks_matching("simp", @io)
    end
    
    should "raise an exception if the first parameter isn't recognized" do
      assert_raises(RuntimeError) { @tlb.to(99) }
    end
  end
  
  context "a task builder with a couple of tasks" do
    setup do 
      @tlb = Wanna::TasklistBuilder.new
      @ran = "nothing was run"
      @tlb.to("task1") { @ran = "TASK1" }
      @tlb.to("task2") { @ran = "TASK2" }
      @io = "dummy"
    end                                          
    
    should "run the appropriate task when asked" do
      @tlb.run_target("task1")
      assert_equal "TASK1", @ran
      @tlb.run_target("task2")
      assert_equal "TASK2", @ran      
    end
    
    should "report and error and exit if asked to run an unknown task" do
      STDERR.expects(:puts)
      assert_raises(SystemExit) do
        @tlb.run_target("unknown task")
      end
    end
  end    
  
  context "a task builder with interdependent tasks" do
    setup do
      @tlb = Wanna::TasklistBuilder.new
      @result = []
      @tlb.to("t1", :needs => [ "t2", "t3" ]) { @result << "t1" }
      @tlb.to("t2", :needs => [ "t4" ]) { @result << "t2" }
      @tlb.to("t3", :needs => [ "t4" ]) { @result << "t3" }
      @tlb.to("t4") { @result << "t4" }
    end
    
    should "simply run leaf nodes" do
      @tlb.run_target("t4")
      assert_equal(["t4"], @result)
    end

    should "simply run dependency before target t3" do
      @tlb.run_target("t3")
      assert_equal(["t4", "t3"], @result)
    end

    should "simply run dependency before target t2" do
      @tlb.run_target("t2")
      assert_equal(["t4", "t2"], @result)
    end
     
    should "run dependends accessible multiple ways just once" do
      @tlb.run_target("t1")
      assert_equal "t1", @result.pop
      assert_equal "t4", @result.shift
      assert_equal [ "t2", "t3" ], @result.sort
    end
  end
  
  context "a task builder" do
    setup do
      @tlb = Wanna::TasklistBuilder.new
    end
    
    should "execute a block in context" do
      ran = "not ran"
      @tlb.interpret do
        to("task1") { ran = "ran" }
      end
      assert_equal "not ran", ran
      @tlb.run_target("task1")
      assert_equal "ran", ran
    end 
    
    should "return a FileTarget object when the create() method is called" do
      assert_equal Wanna::FileTarget, @tlb.create("a.b").class
    end
  end
end