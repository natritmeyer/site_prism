require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'reek/rake/task'

namespace :cuke do
  Cucumber::Rake::Task.new(:all) do |t|
    t.cucumber_opts = "--format pretty"
  end

  Cucumber::Rake::Task.new(:wip) do |t|
    t.cucumber_opts = "--format pretty -t @wip"
  end
end

namespace :spec do
  RSpec::Core::RakeTask.new(:all) do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.ruby_opts = "-I lib"
  end
end

namespace :code do
  Reek::Rake::Task.new do |t|
    t.config_files = "config.reek"
    t.source_files = "**/*.rb"
    t.fail_on_error = false
    t.reek_opts = "-q"
  end
end

