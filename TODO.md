### Backlog:
-  code-coverage - line to fix up: `spec/page_spec.rb:91`
-  Look to rework suite-wide Gherkin
    - Introduce Hooks to cache Page objects on a per-test basis (Should save a few fractions)
    - Don't memoize the individual page calls just incase (Also goes against readme)
    - Expand on existing large scale features and try tear down into more relevant ones
-  `page_element_interaction_steps.rb:49` Shouldn't be there as its performing Actions
-  `site_prism/addressable_url_matcher.rb` - Needs more of a spring clean
-  `SitePrism::Page#wait_until_displayed` - Re-call existing method and re-raise
-  Begin to refactor `displayed?(*args)`, to remove enumerable args (Shouldn't be enumerable)
-  New feature `SitePrism::Section#native` returning `root_element.native` To help with
people wanting to access the base native object (Honouring what maintainers said)
-  element/s spec need a slight rename / tidy
-  Update of Ruby Version to supported version
-  Rubocop LineLength reduction (Continue this, will be hard work, probably several PR's)
-  Rubocop MethodLength reduction (Should be a small-er PR)
-  Begin to start using let blocks across specs (Dev points update)
-  Create iFrame specs (Even though private methods)
-  Allow scoping iFrames to then be passed into element native object
- Generic suite wide linting in `/lib` need to wrap method arguments up (Remove space separations)
- Generic spec walkthrough - (have done `sections_spec.rb` - which might need renaming)

### To monitor (Assumed fixed elsewhere)
-  Capybara compatibility around iFrames - Now should be more compatible. Remove once 2.12 is released

### Bug
- Waiter.default_wait_time is not being called inter-suite. And is somehow being hard-coded as 0
When removing this value, and verbosely referencing Capybara, spec times shoot up (And possibly code changes)
Need to ensure `seconds = !args.empty? ? args.first : Waiter.default_wait_time` gets fixed to grab 0
when implicit waits are off, and the Capybara default value when waits are on
NOTE: This only affects specs. The cucumber tests do seem to interrogate this value correctly.
