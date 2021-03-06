$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

%w{ 
  wanna/log
  wanna/environment
  wanna/helpers
  wanna/file_target
  wanna/task
  wanna/task/basic
  wanna/task/file
  wanna/tasklist
  wanna/option_store
  wanna/task
  wanna/task/basic
  wanna/tasklist
  wanna/tasklist_builder 
  wanna/version
}.each do |library|
  require library
end
                           
Wanna::Options = Wanna::OptionStore.new