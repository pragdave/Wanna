require File.expand_path('test_helper', File.dirname(__FILE__))

class TestOptionStore < Test::Unit::TestCase
  
  context "an option store" do
    
    setup do
      @os = Wanna::OptionStore.new
    end
     
    should "have a default option" do
      assert_equal :errors, @os[:tracing]
    end
    
    context "with an option set in the demands file" do
      setup do
        @os.set_demands_file_option(:tracing, :verbose)
      end
      
      should "have that option overridden" do
        assert_equal :verbose, @os[:tracing]
      end
      
      context "and an option set on the command line" do
        setup do
          @os.set_command_line_option(:tracing, :information)
        end

        should "have that option overridden" do
          assert_equal :information, @os[:tracing]
        end
      end
    end

    should "give priority to command line options" do
      @os.set_command_line_option(:tracing, :information)
      @os.set_demands_file_option(:tracing, :verbose)
      assert_equal :information, @os[:tracing]
    end
       
    should "not allow an unknown option to be set" do
      assert_raises(RuntimeError) { @os.set_command_line_option(:wibble, :wobble) }
    end
    
    should "not allow an invalid value to be passed to an option" do
      assert_raises(RuntimeError) { @os.set_command_line_option(:tracing, :wobble) }
    end
  end
end