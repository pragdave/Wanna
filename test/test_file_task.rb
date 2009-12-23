require File.expand_path('test_helper', File.dirname(__FILE__))
require 'wanna/file_target'
require 'wanna/task/file'
require 'mocha'

class TestFileTask < Test::Unit::TestCase


    context "a new file task" do
      setup do 
        @file_target = Wanna::FileTarget.new("a.b")
        @task = Wanna::Task::File.new(@file_target, {}, nil)
      end

      should "have a long name" do
        assert_equal "a.b", @task.name
      end

      should "not have a short name" do
        assert_nil @task.short_name
      end

      should "have a display name" do
        assert_equal "a.b", @task.display_name
      end

      should "not have needs" do
        assert @task.needs.empty?
      end

      should "not use anything" do
        assert @task.uses.empty?
      end 

      should "be out of date if the file does not exist" do
        File.expects(:exist?).with("a.b").returns(nil)
        assert @task.out_of_date?(nil)
      end
      
      should "not be out of date if the file exists and there are no dependencies" do
        File.expects(:exist?).with("a.b").returns(true)
        @file_target.expects(:modified).returns(Time.now)
        assert !@task.out_of_date?(nil)
      end
    end

end