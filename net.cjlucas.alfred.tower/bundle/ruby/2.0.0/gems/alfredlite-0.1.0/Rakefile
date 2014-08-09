$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

#require 'rubygems'
#require 'bundler/setup'

require 'rspec/core/rake_task'

require 'alfredlite/version'

task :default => [:spec]

task :spec do
  RSpec::Core::RakeTask.new do |task|
    task.verbose = false
    task.rspec_opts = '--color'
  end
end


task :build do
  system 'gem build alfredlite.gemspec'
end

task :release => :build do
  system "gem push alfredlite-#{Alfred::VERSION}.gem"
end

task :clean do
  system 'rm -f *.gem'
end
