require 'rubygems'
require 'lib/wanna/version'
 
Gem::Specification.new do |spec|
  
  spec.author = 'Dave Thomas'
  spec.files =  %w{ lib/wanna.rb lib/wanna/**/*.rb }
  
  %w{ shoulda rcov mocha }.each {|dep| spec.add_development_dependency(dep) }
  spec.description = File.read('README.rdoc').sub(/\A= .*\n+/, '').sub(/==.*/m, '')
  spec.email = 'dave@pragprog.com'
  spec.executables = %w{ wanna }
  spec.files = %w{ lib/**/*.rb test/* bin/wanna Demands README.rdoc }.map { |pattern| Dir[pattern] }.flatten
  spec.has_rdoc = false
  spec.homepage = 'http://github.com/pragdave/Wanna'
  spec.name = 'wanna'
  spec.required_ruby_version = '>= 1.8.6'
  spec.requirements << 'A sense of humor'
  spec.summary = 'A simple depedencency-based command execution tool'
  spec.test_files = Dir['test/_*.rb']
  spec.version = Wanna::VERSION + "." + Time.now.to_i.to_s
end