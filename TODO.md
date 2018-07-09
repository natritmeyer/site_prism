### Backlog:
-  `site_prism/addressable_url_matcher.rb` - Needs more of a spring clean
-  `SitePrism::Page#wait_until_displayed` - Re-call existing method and re-raise
-  Update of Ruby Version to supported version
-  Rubocop LineLength reduction (Continue this, will be hard work, probably several PR's)
-  Create iFrame specs (Even though private methods)
- Advanced spec clean. Make sure each spec file represents the right items
- Setup a secondary gemfile to track against older items (As and when we upgrade Ruby/Gem deps)
- Standardise wait key assignment in element container (Work broken out from Capybara3 rework)
- Create Test Helper and isolate all classes into single definition/s (CSS/XPath pages)

Generic Spec walkthrough

addressable - Done
configure - Done
element - Done
elements - Done
iframe - Done
loadable - Done
page - 40% complete
section - TODO
sections - TODO
version - TODO
waiter - TODO