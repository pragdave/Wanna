$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Wanna
  VERSION = '0.0.1'
end 

%w{ 
  wanna/log
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
}.each do |library|
  require library
end
                           
Wanna::Options = Wanna::OptionStore.new