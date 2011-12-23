Gem::Specification.new do |s|
  s.name        = "site_prism"
  s.version     = "0.9"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nat Ritmeyer"]
  s.email       = ["nat@natontesting.com"]
  s.homepage    = "http://github.com/natritmeyer/site_prism"
  s.summary     = "none just yet..."
  s.description = "none just yet..."
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE)
  s.require_path = 'lib'
  s.add_dependency('capybara', '>= 1.1.1')
  s.add_dependency('rspec', '>= 2.0.0')
end