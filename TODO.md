To Update:
1) Capybara 2.1+ compatibility - iFrame stuff
(Need to update `Capybara` restrictions to something less old!)
2) Generic Update of dependencies
3) Documentation of supported rubies
4) Fix up of Gemfile and Gemspec to be inline with community guidelines
See: http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/
5) Update of Ruby Version to supported version

To Re-Triage:
1) `SitePrism::Page#wait_until_displayed`
2) Anonymous sections

To be worked on now:
1) Figure out why the loadable spec isn't playing nicely with code-coverage
One line to tidy up for full compliance: `spec/page_spec.rb:91`
2) Travis:
- Add in multiple rubies
- Add in Chrome
- Update Driver/Browser
3) Fix `page_element_interaction_steps.rb`: Triple Expectations and non-Helper expectation
4) Fix `page_section_steps.rb` - Triple expectations
5) Generic Features are sometimes hard to understand. Look to rework the Gherkin
6) `page_element_interaction_steps.rb:49` Shouldn't be there as its performing Actions
