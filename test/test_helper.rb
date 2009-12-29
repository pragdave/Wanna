require 'rubygems'
require 'test/unit'
require 'shoulda'  
require 'mocha'   
require File.expand_path('../lib/wanna', File.dirname(__FILE__))

Wanna::Options.set_command_line_option(:tracing, :errors)
