begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$KCODE = "UTF-8"
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
require "kizapi"
