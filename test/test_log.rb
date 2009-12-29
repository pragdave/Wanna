require File.expand_path('test_helper', File.dirname(__FILE__))

class TestLog < Test::Unit::TestCase
  context "a logger with tracing set to :errors" do
    should "not log info messages" do
      STDERR.expects(:puts).never
      Wanna::Log.info("hello")
    end
    should "log error messages" do
      STDERR.expects(:puts).once
      Wanna::Log.error("hello")
    end
  end
end