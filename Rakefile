require 'rubygems'
require 'rtask'

RTask.new

#
# bacon
#

desc "Run the specs"
task :spec do
  sh "bacon spec/*.rb"
end

desc "Default task is to run specs"
task :default => :spec
