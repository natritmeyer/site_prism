To Update:
1) Capybara 2.1+ compatibility - iFrame stuff
(Need to update `Capybara` restrictions to something less old!)

_This needs updating to at least 2.6+_ (Inline with last cut of SP development)

2) Generic Update of dependencies
3) Documentation of supported rubies
4) Fix up of Gemfile and Gemspec to be inline with community guidelines
See: http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/

To Re-Triage:
1) `SitePrism::Page#wait_until_displayed`
2) Anonymous sections

To be worked on now:
1) Figure out why the loadable spec isn't playing nicely with code-coverage
One line to tidy up for full compliance: `spec/page_spec.rb:91`
