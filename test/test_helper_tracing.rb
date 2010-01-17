require File.expand_path('test_helper', File.dirname(__FILE__))

class TestHelperTracing < Test::Unit::TestCase 
  
  context "Tracing" do
    
    setup do
      @helper = Object.new.extend(Wanna::Helpers)
    end
    
    should "call an info-level log when say() is called" do
      Wanna::Log.expects(:info).with("hello")
      @helper.say "hello"
    end

    should "call an error-level log when error() is called" do
      Wanna::Log.expects(:error).with("hello")
      @helper.error "hello"
    end
  end
end