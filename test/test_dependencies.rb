require File.expand_path('test_helper', File.dirname(__FILE__))

# It would be nice to be able to use fakefs, but its support for utime isn't there, and
# I don't currently have time for a patch

class TestDependencies < Test::Unit::TestCase
   
  BREAKFAST = Time.local(2009, 12, 25,  8, 0, 0)
  LUNCH     = Time.local(2009, 12, 25, 12, 0, 0)
  DINNER    = Time.local(2009, 12, 25, 18, 0, 0)

  module F   # files we're working with
    TARGET      = "target"
    PARENT      = "parent"
    GRANDPARENT = "grandparent"
    
    def self.tidyup
      constants.each do |const|
        file_name = F.const_get(const)
        FileUtils.rm_f(file_name)
      end
    end
  end

                     
  context "A tasklist" do

    setup do 
      @tlb = Wanna::TasklistBuilder.new 
    end

    teardown do
      F::tidyup
    end
    
    context "with a single basic task" do
      setup do 
        @tlb.to("basic task")
      end    
      should "report that task as out of date" do
        assert @tlb.out_of_date?("basic task")
      end
    end
  
    context "with a single file task" do
      setup do 
        @tlb.to(@tlb.create(F::TARGET))
      end    

      should "report that task as out of date if the file doesn't exist" do
        assert @tlb.out_of_date?(F::TARGET)
      end 
    
      context "where the file exists" do
        setup do
          FileUtils.touch(F::TARGET)
        end
      
        should "report that task as not out of date" do
          assert !@tlb.out_of_date?(F::TARGET)
        end
      end
    end
    
    context "with a single file task and a basic task dependent on it" do
      setup do 
        @tlb.to("basic")
        @tlb.to(@tlb.create(F::TARGET), :needs => "basic")
      end    

      should "report that task as out of date if the file doesn't exist" do
        assert @tlb.out_of_date?(F::TARGET)
      end 
    
      context "where the file exists" do
        setup do
          FileUtils.touch(F::TARGET)
        end
      
        should "report that task is out of date (because the basic task is always out of date)" do
          assert @tlb.out_of_date?("basic")
          assert @tlb.out_of_date?(F::TARGET)
        end
      end
    end

    context "with a single file task and a file task dependent on it" do
      setup do 
        @tlb.to(@tlb.create(F::PARENT))
        @tlb.to(@tlb.create(F::TARGET), :needs => F::PARENT)
      end    

      should "report that task as out of date if the file doesn't exist" do
        assert @tlb.out_of_date?(F::TARGET)
      end 
    
      context "where the file exists" do
        setup do
          TestDependencies.touch(F::TARGET, LUNCH)
        end

        should "report out of date if the required file doesn't exist" do
          assert @tlb.out_of_date?(F::TARGET)
        end
        
        context "and the required file is newer" do
          setup do
            TestDependencies::touch(F::PARENT, DINNER)
          end

          should "be out of date" do
            assert @tlb.out_of_date?(F::TARGET)
          end
        end
        
        context "and the required file is older" do
          setup do 
            TestDependencies::touch(F::PARENT, BREAKFAST)
          end

          should "not be out of date" do
            assert !@tlb.out_of_date?(F::TARGET)
          end
        end
        
        
      end
    end
   
    context "with a task, a parent, and a grandparent" do
      setup do                                                 
        @tlb.to(@tlb.create(F::GRANDPARENT))
        @tlb.to(@tlb.create(F::PARENT), :needs => F::GRANDPARENT)
        @tlb.to(@tlb.create(F::TARGET), :needs => F::PARENT)
      end
      
      context "where the grandparent is older than the parent and the parent is older that the target" do
        setup do
          TestDependencies::touch(F::GRANDPARENT, BREAKFAST)
          TestDependencies::touch(F::PARENT,      LUNCH)
          TestDependencies::touch(F::TARGET,      DINNER)
        end
        
        should "not be out of date" do
          assert !@tlb.out_of_date?(F::TARGET)
          assert !@tlb.out_of_date?(F::PARENT)
          assert !@tlb.out_of_date?(F::GRANDPARENT)
        end
      end 

      context "where the grandparent is younger than the parent and the parent is older that the target" do
        setup do
          TestDependencies::touch(F::GRANDPARENT, LUNCH)
          TestDependencies::touch(F::PARENT,      BREAKFAST)
          TestDependencies::touch(F::TARGET,      DINNER)
        end
        
        should "be out of date" do
          assert @tlb.out_of_date?(F::TARGET)
          assert @tlb.out_of_date?(F::PARENT)
          assert !@tlb.out_of_date?(F::GRANDPARENT)
        end
      end 
      
    end
    
   end
  
  
  ####
  # Local elpers
  #
  
  def self.touch(filename, mtime)
    # touch doesn't set mtime if it creates the file (arguably a bug)
    FileUtils.touch(filename) unless File.exist?(filename) 
    FileUtils.touch(filename, :mtime => mtime)
  end
  

end