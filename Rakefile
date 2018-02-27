# frozen_string_literal: true

task :cukes do
  @cuke_exit_code = system 'bundle exec cucumber' || raise('Cukes failed')
end

task :specs do
  @spec_exit_code = system 'bundle exec rspec' || raise('Specs failed')
end

task :rubocop do
  @cops_exit_code = system 'bundle exec rubocop' || raise('Cops failed')
end

task :default do
  Rake::Task[:rubocop].invoke
  Rake::Task[:specs].invoke
  Rake::Task[:cukes].invoke
  (@cuke_exit_code && @spec_exit_code && @cops_exit_code) || raise('Failed to pass all 3')
end
