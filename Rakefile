require 'rake/testtask'
require 'rubocop/rake_task'

task :default => [:test]
task :test => [:rubocop]

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

RuboCop::RakeTask.new
