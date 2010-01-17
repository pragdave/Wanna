require File.expand_path('test_helper', File.dirname(__FILE__))

class TestHelperModule < Test::Unit::TestCase
  
  context "The helper module" do
    context "when passed a module containing methods" do
      setup do
        Wanna::Helpers.for("a test") do
          puts "INCLUDING"
          def meth1; end
          def meth2; end
        end unless Wanna::Helpers.instance_methods.include?("meth1")
      end
      
      should "add those methods to itself" do
        assert Wanna::Helpers.instance_methods.include? "meth1"
        assert Wanna::Helpers.instance_methods.include? "meth2"
      end 
      
      should "return those methods (and others) when asked for a list" do
        io = Object.new   
        io.expects(:puts).at_least_once
        io.expects(:puts).with("a test")
        io.expects(:puts).with("    meth1, meth2")
        Wanna::Helpers.list(io)
      end
    end
  end
end