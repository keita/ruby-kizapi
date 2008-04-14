require 'rubygems'
require 'rtask'

RTask.new(:use => :all, :version => KizAPI::VERSION)

#
# bacon
#

desc "Run the specs"
task :spec do
  sh "bacon spec/*.rb"
end

desc "Default task is to run specs"
task :default => :spec
