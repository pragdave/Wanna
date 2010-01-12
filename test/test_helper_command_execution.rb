require File.expand_path('test_helper', File.dirname(__FILE__))

class TestHelperCommandExecution < Test::Unit::TestCase 
  
  context "Executing a shell command with command tracing disabled" do
    
    setup do
      Wanna::Options.set_command_line_option(:show_commands, false) 
      @helper = Object.new.extend(Wanna::Helpers::CommandExecution)
    end
    
    should "invoke Kernel::system" do
      @helper.expects(:system).with("some command").returns(true)
      @helper.sh("some command")
    end

    should "report an error and exit if the command fails" do
      Wanna::Log.expects(:error)
      @helper.expects(:system).with("some command").returns(false)
      @helper.expects(:exit).with(1)
      @helper.sh("some command")
    end
  end
  
  context "Executing a shell command with command tracing enabled" do
    
    setup do
      Wanna::Options.set_command_line_option(:show_commands, true) 
      @helper = Object.new.extend(Wanna::Helpers::CommandExecution)
    end
    
    should "trace the command and invoke Kernel::system" do
      Wanna::Log.expects(:log_with_timestamp).with(:command, "sh some command")
      @helper.expects(:system).with("some command").returns(true)
      @helper.sh("some command")
    end

    should "report an error and exit if the command fails" do
      Wanna::Log.expects(:log_with_timestamp).with(:command, "sh some command")
      Wanna::Log.expects(:error)
      @helper.expects(:system).with("some command").returns(false)
      @helper.expects(:exit).with(1)
      @helper.sh("some command")
    end
  end
  
  context "the ruby() helper" do
    require 'rbconfig'
    
    setup do
      Wanna::Options.set_command_line_option(:show_commands, false) 
      @helper = Object.new.extend(Wanna::Helpers::CommandExecution)
      @ruby = File.join(::Config::CONFIG["bindir"], ::Config::CONFIG["ruby_install_name"])
    end
    
    should "run the current ruby interpreter" do
      @helper.expects(:system).with("#{@ruby} a b").returns(true)
      @helper.ruby("a b")
    end
    
    should "concatenate any array options" do
      @helper.expects(:system).with("#{@ruby} a b").returns(true)
      @helper.ruby(["a", ["b"]])
    end
    
  end
  
end