### Backlog:
-  code-coverage - line to fix up: `spec/page_spec.rb:91`
-  `site_prism/addressable_url_matcher.rb` - Needs more of a spring clean
-  `SitePrism::Page#wait_until_displayed` - Re-call existing method and re-raise
-  Begin to refactor `displayed?(*args)`, to remove enumerable args (Shouldn't be enumerable)
-  Update of Ruby Version to supported version
-  Rubocop LineLength reduction (Continue this, will be hard work, probably several PR's)
-  Rubocop MethodLength reduction (Should be a small-er PR)
-  Create iFrame specs (Even though private methods)
-  Allow scoping iFrames to then be passed into element native object
- Generic spec walkthrough - (have done section/sections/element/elements)

### Bug
- Waiter.default_wait_time is not being called inter-suite. And is somehow being hard-coded as 0
When removing this value, and verbosely referencing Capybara, spec times shoot up (And possibly code changes)
Need to ensure `seconds = !args.empty? ? args.first : Waiter.default_wait_time` gets fixed to grab 0
when implicit waits are off, and the Capybara default value when waits are on
NOTE: This only affects specs. The cucumber tests do seem to interrogate this value correctly.
