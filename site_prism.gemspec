require './lib/site_prism/version'

Gem::Specification.new do |s|
  s.name        = "site_prism"
  s.version     = SitePrism::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nat Ritmeyer"]
  s.email       = ["nat@natontesting.com"]
  s.homepage    = "http://github.com/natritmeyer/site_prism"
  s.summary     = "A Page Object Model DSL for Capybara"
  s.description = "SitePrism gives you a simple, clean and semantic DSL for describing your site using the Page Object Model pattern, for use with Capybara"
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.require_path = 'lib'
  s.add_dependency 'capybara', ['>= 2.0.2', '< 3.0']
  s.add_dependency 'rspec', '~> 2.0'
end

