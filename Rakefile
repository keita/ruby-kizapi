require 'rubygems'
require 'rake'
require 'yaml'
require 'fileutils'

require File.join(File.dirname(__FILE__), 'lib', 'kizapi')

#
# RubyForge
#

$config =
  YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))

#
# Clean
#

require 'rake/clean'

CLEAN.include ['**/.*.sw?', '*.gem', '*.tgz', '.config', '**/.DS_Store']

#
# RDoc
#

require 'rake/rdoctask'

Rake::RDocTask.new do |doc|
  doc.title = "ruby-kizapi-#{KizAPI::VERSION} documentation"
  doc.main = "README.txt"
  doc.rdoc_files.include("{README,History,License}.txt", "lib/**/*.rb")
  doc.options << "--line-numbers" << "--inline-source" << "-c UTF-8"
end

require 'rake/contrib/rubyforgepublisher'

desc "Upload API documentation"
task :publish => [:rdoc] do
  pub = Rake::RubyForgePublisher.new("kizapi", $config["username"])
  pub.upload
end

#
# Release
#

desc 'Release new gem version'
task :release do
  filename = "kizapi-#{KizAPI::VERSION}"
  if File.exist?(filename + ".gem") and File.exist?(filename + ".tgz")
    sh "rubyforge add_release kizapi kizapi #{KizAPI::VERSION} #{filename}.gem"
    sh "rubyforge add_file kizapi kizapi #{KizAPI::VERSION} #{filename}.tgz"
    puts "Released #{filename}.gem and #{filename}.tgz"
  else
    puts "Please make gem and tgz files first"
    exit
  end
end

#
# Create gem
#

desc "Create the gem package"
task :gem do
  sh "gemify -I"
end

#
# Create tgz
#

desc "Create the tgz package"
task :tgz do
  tgz = "kizapi-#{KizAPI::VERSION}.tgz"
  sh "tar -T Manifest.txt -c -z -f #{tgz}"
end

#
# bacon
#

desc "Run the specs"
task :spec do
  sh "bacon spec/*.rb"
end

desc "Default task is to run specs"
task :default => :spec
