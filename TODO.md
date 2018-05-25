### Backlog:
-  `site_prism/addressable_url_matcher.rb` - Needs more of a spring clean
-  `SitePrism::Page#wait_until_displayed` - Re-call existing method and re-raise
-  Begin to refactor `displayed?(*args)`, to remove enumerable args (Shouldn't be enumerable)
-  Update of Ruby Version to supported version
-  Rubocop LineLength reduction (Continue this, will be hard work, probably several PR's)
-  Rubocop MethodLength reduction (Should be a small-er PR)
-  Create iFrame specs (Even though private methods)
-  Allow scoping iFrames to then be passed into element native object
- Generic spec walkthrough - (have done section/sections/element/elements/top half of page)
