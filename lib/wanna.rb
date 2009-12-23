$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Wanna
  VERSION = '0.0.1'
end 

require 'wanna/task'
require 'wanna/task/basic'

require 'wanna/tasklist'
require 'wanna/tasklist_builder'
