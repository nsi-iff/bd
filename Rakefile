#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'

RSpec::Core::RakeTask.new(:jenkins => ["ci:setup:rspec"]) do |t|
  t.pattern = '**/*_spec.rb'
  t.rspec_opts = ['--format html:results/spec_results.html']
end

DigitalLibrary::Application.load_tasks
