require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/test*.rb']
  t.warning = true
  t.verbose = false
end    

task "a" => [ "b", "c"] do
  puts "a"
end

task "b" => "d" do
  puts "b"
end

task "c" => "d" do
  puts "c"
end

task "d" do
  puts "d"
end