require File.expand_path('test_helper', File.dirname(__FILE__))

class TestHelperTesting < Test::Unit::TestCase 
  
  context "Helper methods in Testing" do
    
    setup do
      @helper = Object.new.extend(Wanna::Helpers)
     
      # expose the private methods
      def @helper.set_instance_variable_options(*); super; end
      def @helper.cmd_line_escape(*); super; end
      
      @defaults = { :opt1 => "one", :opt2 => "two"}
    end
    
    context "When setting options to helper methods" do
    
      should "not override a default if no corresponding option passed" do
        @helper.set_instance_variable_options({}, "name", @defaults)
        assert_equal @defaults[:opt1], @helper.instance_variable_get("@opt1")
        assert_equal @defaults[:opt2], @helper.instance_variable_get("@opt2")
      end

      should "override a default if no corresponding option passed" do
        @helper.set_instance_variable_options({:opt2 => "2"}, "name", @defaults)
        assert_equal @defaults[:opt1], @helper.instance_variable_get("@opt1")
        assert_equal "2", @helper.instance_variable_get("@opt2")
      end

      should "reject setting an invalid option" do
        assert_raises(RuntimeError) { @helper.set_instance_variable_options({:opt3 => 1}, "name", @defaults)}
      end
    end
  
    context "escape filename for the command line" do
      
      should "pass through a regular name" do
        assert_equal "name.rb", @helper.cmd_line_escape("name.rb")
      end

      should "add a flag to a regular name" do
        assert_equal "-x name.rb", @helper.cmd_line_escape("name.rb", "-x")
      end

      should "convert an array of names to a string" do
        assert_equal "name1.rb name2.rb name3.rb", @helper.cmd_line_escape(%w{ name1.rb name2.rb name3.rb})
      end

      should "add a flag to an array of regular names" do
        assert_equal "-x name1.rb -x name2.rb -x name3.rb", @helper.cmd_line_escape(%w{ name1.rb name2.rb name3.rb}, "-x")
      end
      
      should "escape a name containing a single quote" do
        assert_equal %{"a'b"}, @helper.cmd_line_escape("a'b")
      end
      
      should "escape a name containing a space" do
        assert_equal %{'a b'}, @helper.cmd_line_escape("a b")
      end
      
      should "escape a name containing a double quote" do
        assert_equal %{'a"b'}, @helper.cmd_line_escape('a"b')
      end
    end
    
    context "running regular tests" do
      should "default to running tests/*.rb with lib included" do
        Dir.expects(:glob).with("test/*.rb").returns(%w{test/a.rb test/b.rb})
        @helper.expects(:ruby).with("-e 'ARGV.each {|f| load f}'", ' -I lib', ['test/a.rb', 'test/b.rb'])
        @helper.run_tests
      end
      should "allow lib to be overridden" do
        Dir.expects(:glob).with("test/*.rb").returns(%w{test/a.rb test/b.rb})
        @helper.expects(:ruby).with("-e 'ARGV.each {|f| load f}'", ' -I mylib', ['test/a.rb', 'test/b.rb'])
        @helper.run_tests(:lib => "mylib")
      end
      should "allow the test filename pattern to be overridden" do
        Dir.expects(:glob).with("unit/test*.rb").returns(%w{unit/test_a.rb})
        @helper.expects(:ruby).with("-e 'ARGV.each {|f| load f}'", ' -I mylib', ['unit/test_a.rb'])
        @helper.run_tests(:lib => "mylib", :pattern => "unit/test*.rb")
      end
    end


    context "running rcov" do
      should "default to running tests/*.rb with lib included" do
        @helper.expects(:sh).with("rcov -I lib test/*.rb")
        @helper.run_rcov
      end
      should "allow lib and pattern to be overridden" do
        @helper.expects(:sh).with("rcov -I mylib test/test*.rb")
        @helper.run_rcov(:lib => "mylib", :pattern => "test/test*.rb")
      end
      should "support the :include option" do
        @helper.expects(:sh).with("rcov -I mylib -i includes test/test*.rb")
        @helper.run_rcov(:lib => "mylib", :pattern => "test/test*.rb", :include => "includes")
      end
      should "support the :exclude option" do
        @helper.expects(:sh).with("rcov -I mylib -x excludes test/test*.rb")
        @helper.run_rcov(:lib => "mylib", :pattern => "test/test*.rb", :exclude => "excludes")
      end
      
      # should "allow lib to be overridden" do
      #   Dir.expects(:glob).with("test/*.rb").returns(%w{test/a.rb test/b.rb})
      #   @helper.expects(:ruby).with("-e 'ARGV.each {|f| load f}'", ' -I mylib', ['test/a.rb', 'test/b.rb'])
      #   @helper.run_tests(:lib => "mylib")
      # end
      # should "allow the test filename pattern to be overridden" do
      #   Dir.expects(:glob).with("unit/test*.rb").returns(%w{unit/test_a.rb})
      #   @helper.expects(:ruby).with("-e 'ARGV.each {|f| load f}'", ' -I mylib', ['unit/test_a.rb'])
      #   @helper.run_tests(:lib => "mylib", :pattern => "unit/test*.rb")
      # end
    end
  end
end