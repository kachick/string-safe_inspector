# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rake/testtask'

begin
  require 'rubocop/rake_task'
rescue LoadError
  puts 'can not use rubocop in this environment'
else
  RuboCop::RakeTask.new
end

task default: [:test_behaviors]

task test_behaviors: [:test]

desc 'Simulate CI results in local machine as possible'
multitask simulate_ci: [:test_behaviors, :validate_signatures, :rubocop]

Rake::TestTask.new(:test) do |tt|
  tt.pattern = 'test/**/test_*.rb'
  tt.warning = true
end

desc 'Signature check, it means `rbs` and `YARD` syntax correctness'
multitask validate_signatures: [:'signature:validate_yard', :'signature:validate_rbs']

namespace :signature do
  desc 'Validate `rbs` syntax, this should be passed'
  task :validate_rbs do
    sh 'bundle exec rbs -I sig validate'
  end

  desc 'Check `rbs` definition with `steep`, but it faults from some reasons ref: #26'
  task :check_false_positive do
    sh 'bundle exec steep check --log-level=fatal'
  end

  desc 'Generate YARD docs for the syntax check'
  task :validate_yard do
    sh "bundle exec yard --fail-on-warning #{'--no-progress' if ENV['CI']}"
  end
end

desc 'Prevent miss packaging!'
task :view_packaging_files do
  sh 'rm -rf ./pkg'
  sh 'rake build'
  cd 'pkg' do
    sh 'gem unpack *.gem'
    sh 'tree -I *\.gem'
  end
  sh 'rm -rf ./pkg'
end
