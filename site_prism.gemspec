require './lib/site_prism/version'

Gem::Specification.new do |s|
  s.name        = 'site_prism'
  s.version     = SitePrism::VERSION
  s.required_ruby_version = '>= 1.9.3'
  s.platform    = Gem::Platform::RUBY
  s.license     = 'BSD3'
  s.author      = 'Nat Ritmeyer'
  s.email       = 'nat@natontesting.com'
  s.homepage    = 'http://github.com/natritmeyer/site_prism'
  s.summary     = 'A Page Object Model DSL for Capybara'
  s.description = 'SitePrism gives you a simple, clean and semantic DSL for describing your site using the Page Object Model pattern, for use with Capybara'
  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.require_path = 'lib'
  s.add_dependency 'capybara', ['>= 2.1', '< 3.0']
  s.add_dependency 'addressable', ['>=2.3.3', '< 3.0']

  s.add_development_dependency 'rspec', '< 4.0'
end
