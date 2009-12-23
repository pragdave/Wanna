require File.expand_path('test_helper', File.dirname(__FILE__))
require 'wanna/file_target'
require 'mocha'

class TestFileTarget < Test::Unit::TestCase
  context "The exist? method of a file target" do
    setup do 
      @file_target = Wanna::FileTarget.new("a.b")
    end
    should "return false if its target doesn't exist" do
      File.expects(:exist?).with("a.b").returns(nil)
      assert !@file_target.exist?
    end
    should "return true if its target does exist" do
      File.expects(:exist?).with("a.b").returns(true)
      assert @file_target.exist?
    end
  end

  context "The modified time of a file target" do
    setup do 
      @file_target = Wanna::FileTarget.new(__FILE__)
    end
    
    should "be the mtime of the file itself" do
      assert_equal File.stat(__FILE__).mtime, @file_target.modified
    end
  end
  
  context "The target name of a file target" do
    setup do 
      @file_target = Wanna::FileTarget.new("a.b")
    end
    should "be the name of the file" do
      assert_equal "a.b", @file_target.as_target_name
    end
  end

end