# frozen_string_literal: true

task :cukes do
  system 'bundle exec cucumber'
end

task :specs do
  system 'bundle exec rspec'
end

task :rubocop do
  system 'bundle exec rubocop'
end

task default: %i[rubocop specs cukes]
