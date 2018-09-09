<!-- #320 - Sep 9th - Last update to this document -->
## [3.0.beta] - 2018-09-15
### Removed
- `wait_for_<element>` and `wait_for_no_<element>` have been removed
  - As per deprecation warnings, users should use the regular methods with a `wait` parameter
([luke-hill])

- All SitePrism configuration options:
  - The default load validations have been removed, detailed in the Upgrading docs
  - `raise_on_wait_fors` was only triggered on the `wait_for` / `wait_for_no` methods
  - Implicit waiting is now hard-coded to always be on.
    - This can be overridden at runtime by using a `wait` key
    - You can still not use implicit waits by setting `Capybara.default_max_wait_time = 0`
([luke-hill])

### Added
- An UPGRADING.md document to help facilitate the switch from SitePrism v2 to v3
([luke-hill])

- A warning message is thrown when a user sets any configuration option using `SitePrism.configure`
([luke-hill])

### Changed
- Most error message classes have been re-written into a more Ruby naming scheme (Ending in Error)
  - The previously aliased names have all been removed
  - The `error.rb` file details the previous names to help with the transition
([luke-hill])

- Upped Version Dependency of `selenium-webdriver` to `~> 3.6`
([luke-hill])

- SitePrism will now use the configured Capybara wait time to implicitly wait at all times
([luke-hill])

### Fixed
- The names/locations of some waiting tests, which were testing implicit instead of explicit waits
([luke-hill])

## [2.17] - 2018-09-07
### Removed
- `collection` has been removed from the SitePrism DSL (Was just an alias of `sections`)
([luke-hill])

### Changed
- Made all configuration options throw deprecation warnings
([luke-hill])
- Advised users of a better way to use in-line waiting keys instead of `wait_for_*` methods (Deprecated)
([luke-hill])

## [2.16] - 2018-08-22
### Added
- A configuration switch to toggle the default Page Load Validation behaviours (By default set to on)
([luke-hill])

### Changed
- Refactored the way in which the procedural `Loadable` block is set for `SitePrism::Page`
([luke-hill])

- Upped Version Dependencies
  - `capybara` must be at least `2.15`
  - `selenium-webdriver ~> 3.5`
  - **Required Ruby Version is now 2.2+**
([luke-hill])

- Altered HISTORY.md into more hyperlinked and declarative format
([luke-hill]) & ([JaniJegoroff])

- Tidied up the Sample HTML files so they had less un-required information
([luke-hill])

- Refactored the way the `wait` key is assigned for all meta-programmed methods
  - Now assigned in a consistent way across all methods
  - Method set-up for further refactors due in v3 (Standardisation of API)
([luke-hill])

### Fixed
- Spec locations (All are now in correct files)
([luke-hill])

- README / rubocop fixes
([luke-hill])

## [2.15.1] - 2018-07-20
### Added
- Initial backwards compatible work for rewriting the Error protocols for site_prism 3.0
  - All Error Classes inherit from one common Error Class
  - All names have suffix `Error`
([luke-hill])

### Changed
- Add ability to test multiple gemfiles in travis
([luke-hill])

- Removed all constants aside from `VERSION`
([luke-hill])

- Improve runtime of cucumber tests by around 30% overall by tweaking some internal JS code
([luke-hill])

- Upped Capybara Version Dependency `capybara >= 2.14, < 3.3`
([luke-hill])

- Altered travis config to test for lowest gem configuration permissible in site_prism
([luke-hill])

### Fixed
- Fixed up some unit tests to cover pages defined with differing selectors
([luke-hill])

- README fixes
([luke-hill])

- Fix scoping issue that prevented iFrames / JS methods defined inside a `section` working
([ineverov])

## [2.15] - 2018-07-09
### Added
- Added more gem metadata into the `.gemspec` file to be read by RubyGems (Changelog e.t.c.)
([luke-hill])

- Enabled support for Capybara 3. Making sure suite is backwards compatible
([luke-hill])

- Added a huge portion of new feature tests to validate timings RE implicit/explicit waits
([tgaff])

### Fixed
- rubocop fixes
([ineverov])

- Fix implicit waiting not working for some DSL defined methods
([luke-hill]) & ([tgaff])

- Add better error message when iFrame's are called without a block (Than a stacktrace)
([luke-hill]) & ([mdesantis])

## [2.14] - 2018-06-22
### Removed
Previously deprecated `Waiter.default_wait_time` (As this just called the Capybara method)
([luke-hill])

### Added
- Introduced new sister method to `#expected_elements` - `#elements_present`
  - This will return an Array of every Element that is present on the Page/Section
([luke-hill])

- Enabled ability to set default search arguments inside a Section
  - If set then a section will set `@root_element` to be defined from `.set_default_search_arguments`
  - If unset / overridden. You are able to still define them in-line using the DSL
([ineverov])

- Testing for Ruby 2.5 on Travis
([luke-hill])

### Changed
- Tidied up specs and made Code Coverage 100% compliant
([luke-hill])

- Upped Development Version Dependencies
  - `selenium-webdriver ~> 3.4`
  - `rubocop ~> 52.0`
([luke-hill])

- Rewrite `ElementContainer` by using `klass.extend`, removing several `self.class` calls
([ineverov]) 

- Added positive and negative timing tests to several scenarios in `waiting.feature`
([luke-hill])

### Fixed
- Fixed waiting bug that caused `Waiter.default_wait_time` not to wait the correct duration
  - Bug only seemed to be present when implicit waits were toggled on
([luke-hill])

- Removed references to `Timeout.timeout` as this isn't threadsafe
([twalpole])

- Fixed issue where multiple runtime arguments weren't set at run-time (ignored by Capybara)
([twalpole])

- rubocop fixes
([ineverov]) & ([jgs731])

## [2.13] - 2018-05-21
### Removed
Removed testing for Ruby `2.0` on Travis
([luke-hill])

### Added
- Added new development docs to aid new and existing contributors
([luke-hill])

- Added Feature to wait for non-existence of element/section
([ricmatsui])

- Introduced configuration to raise an Exception after running `wait_for` methods
  - These aren't in sync with others, and this configuration option will be removed in time!
([ricmatsui])

### Changed
- Refactored Waiter Class
  - cleaner `.wait_until_true`
  - deprecated `.default_wait_time`
([luke-hill])

- Updated Suite Ruby Requirements (**Minimum Ruby is now `2.1`**)
([luke-hill])

- Internal testing tweaks
  - Updated cucumber dependency to `3.0.1` (Allowing new syntax testing)
  - Cleaned up cucumber tests into more granular structure
  - Altered output of RSpec to show test names
  - Unlock testing on Selenium up to `3.10`
([luke-hill])

- Use `shared_examples` in RSpec tests to enhance coverage and check xpath selectors
([luke-hill])

### Fixed
- README fixes
([robd])

## [2.12] - 2018-04-20
### Added
- Added Ruby `2.4` testing to Travis
([luke-hill])

- Update Travis Environment to now test on Chrome and Firefox
([RustyNail]) & ([luke-hill])

### Changed
- Updated development dependencies to be a little more up to date
([luke-hill])

- Allow iFrames to be specified using any selector (ID / Class / XPath / Index)
([ricmatsui])

- Upped Development Dependency of Selenium (3.4 - 3.8)
([luke-hill])

- Expose the `#native` method on Section Objects
([luke-hill])

### Fixed
- README / rubocop / Test / TODO fixes
([luke-hill])

- Fix suite incidentally masking several issues due to incorrect cucumber setup
([luke-hill])

- Fix issue where within a section, we lose our scoping
  - This is due to leveraging `Capybara::DSL`. We need to rescope `#page` to `#root_element`
([ilyasgaraev])

- Performed a suite-wide cleanup of Gherkin. Made everything a lot more organised
([luke-hill])

## [2.11] - 2018-03-07
### Added
- Re-enable Rubocop compliance from PR signoff (Including fixing up some offences)
([RustyNail])

- Allow `#all_there?` to be extended in the DSL with `#expected_elements`
  - This Allows pages to stipulate that some elements may not be there
  - This facilitates testing pages with error messages much easier
([TheMetalCode])

### Changed
- Use the `.gemspec` file for all gem versions and remove any references to gems in `Gemfile`
([luke-hill]) & ([tgaff])

- Compressed `Rakefile` into smaller tasks for Increased Verbosity on Failures
([luke-hill])

- Update Travis to test on a variety of rubies: `2.0 -> 2.3`, using the latest geckodriver
([luke-hill])

- Refactored SitePrism's Addressable library so its slightly less confusing to debug
([luke-hill])

### Fixed
- Fix bug where SitePrism failed load-validation's when passed Block Parameters with no URL
([kei2100])

- README / rubocop fixes
([luke-hill])

## [2.10] - 2018-02-23
### Removed
- Disable Rubocop compliance from PR signoff whilst suite is still being reworked
  - Fixes coming soon to future releases
  - Will be switched on once the suite is stabilised
([luke-hill])

### Added
- Added base contributing / issue templates
([luke-hill])

- Established Roadmap of items to be fixed in coming months
([luke-hill])

- Reworked specs / developmental code to read better
  - Established a base "correct syntax"
  - Improved performance slightly in block code
([luke-hill])

### Changed
- Upped Version Dependencies
  - `capybara ~> 2.3`
  - `rspec ~> 3.2`
  - Required Ruby Version is now 2.0+
([luke-hill])

- Capped Development dependencies for `cucumber (2.4)` and `selenium-webdriver (3.4)` 
  - Establish a baseline for what is expected with these dependencies
  - Suite is still being reworked (So unsure of what results to expect)
([luke-hill])

- Reworked all text files into Markdown structure to allow formatting
([luke-hill])

### Fixed
- Travis Fixes
  - Not pulling in geckodriver dependency
  - Ubuntu container being EOL is now remedied (Using trusty)
([RustyNail])

- Allow `#all_there?` to use in-line configured implicit wait (Still defaulted to false)
([RustyNail])

- README / rubocop fixes
([luke-hill]) & ([iwollmann])

## [2.9.1] - 2018-02-20
### Removed
- Travis tests for EOL Rubies (`2.0` / `2.1` / `2.2`)
([natritmeyer])

- Codebase cleanup of non-used config files
([luke-hill])

### Changed
- Bumped Travis Ruby version from `2.2` to `2.3`
([natritmeyer])

- Upped Version Dependency of `addressable` to `~> 2.4`
([luke-hill])

### Fixed
- README / rubocop fixes
([whoojemaflip]) & ([natritmeyer]) & ([luke-hill])

- Fixed namespace clashes with sections and rspec
([tobithiel])

- Improved Codecoverage pass-rate from `85%` to `99%` (1 outstanding item)
([luke-hill])

## [2.9] - 2016-03-29
### Removed
- Travis tests for Ruby `1.9.x` versions, Travis only tests on 2.0+
([natritmeyer])

### Added
- Implement new `Loadable` behaviour for pages and sections
  - This will allow you to add procs that get executed when you call `#load`
  - Also checks that the page is displayed before continuing
([tmertens])

- Added ability to use block syntax inside a `section` (Previously only iFrames could)
([tgaff])

### Fixed
- README / rubocop fixes
([nitinsurfs]) & ([cantonic]) & ([bhaibel]) & ([natritmeyer])

- Fix a Section Element calling `#text` incorrectly returning the full page text
([ddzz])

## [2.8] - 2015-10-30
### Removed
- `reek` as we have `rubocop`
([natritmeyer])

### Added
- Add ruby 2.2 to rubies used in Travis
([natritmeyer])

### Changed
- Use the latest version of Capybara's waiting time method
  - `#default_max_wait_time` from Capybara 2.5 onwards
  - `#default_wait_time` for 2.4 and below
([tpbowden]) & ([mnohai-mdsol]) & ([tmertens])

- Simplified `#secure?` method
([benlovell])

### Fixed
- Fix up rubocop issues from suite updates
([tgaff])

- README doc fixes
([khaidpham])

## [2.7] - 2015-04-23
### Added
- Allow `#load` to be passed an HTML block to facilitate cleaner view tests
([rugginoso])

- Spring clean of the code, integrated suite with `rubocop`
([jonathanchrisp])

- Test on ruby 2.1 as an additional part of sign-off procedure in Travis
([natritmeyer])

- SitePrism can now leverage URL component parts during the matching process
  - Substituting all parts of url_matcher into the relevant types (port/fragment e.t.c.)
  - Only pass the matching test after each component part matches the `url_matcher` set
([jmileham])
  
- Added check for block being passed to page (Will raise error accordingly)
([sponte])

### Changed
- Altered legacy RSpec syntax in favour of `expect` in tests
([petergoldstein]) 

- Extend `#displayed?` to work when a `url_matcher` is templated
([jmileham])

### Fixed
- README doc fixes
([vanburg]) & ([csgavino])

- Amended issues that occurred on RSpec 3 by making the suite agnostic to the version used
([tgaff]) & ([natritmeyer])

- Internal test suite altered to avoid conflicting with Capybara's `#title` method
([tgaff])

## [2.6] - 2014-02-11
### Added
- Added anonymous sections (That need no explicit Class declaration)
([bassneck])

### Changed
- Upped Version Dependency of rspec to `< 4.0`, and altered it to be a development dependency
([soulcutter]) & ([KarthikDot]) & ([natritmeyer])

### Fixed
- README / License data inconsistencies
([dnesteryuk]) & ([natritmeyer])

- Using runtime options but not specifying a wait time would throw a Type mismatch error
  - This will now default to `Capybara.default_max_wait_time` if implicit waiting is enabled
  - This won't wait if implicit waiting is disabled
([tgaff])

## [2.5] - 2013-10-28
### Added
- Allowed iFrames to be selected by index
([mikekelly])

- Integrated a Rack App into the suite to allow for enhanced spec testing
([natritmeyer])

- `site_prism` gem now does lazy loading
([mrsutter])

- `SitePrism::Waiter.wait_until_true` class method now re-evaluates blocks until they pass as true
([tmertens])

- Improved `capybara` integration to allow runtime arguments to be passed into methods
([tmertens])

- Added configuration for the entire Suite to use implicit waits (Default configured off)
([tmertens])

### Changed
- README tweaks relevant to the new version of the gem
([abotalov]) & ([natritmeyer]) & ([tommyh])

### Fixed
- README inconsistencies fixed
([antonio]) & ([LukasMac]) & ([Mustang949])

- Allow `#displayed?` test used in load validations to use newly made `Waiter` class to avoid false failures
([tmertens])

- Changed `#set_url` to convert its input to a string - fixing method inconsistencies
([modsognir])

## [2.4] - 2013-05-18
### Added
- Added `#has_no_<thing>?`, to test for non-presence
([johnwake])

### Changed
- `site_prism` now uses `Capybara::Node::Finders#find` instead of `#first` to locate an element / section
([natritmeyer])

- Upped Version Dependency of capybara to `~> 2.1`
([natritmeyer])

- `SitePrism::Page#title` now returns `""` instead of `nil` when there is no title
([natritmeyer])

- Altered suite configuration to ignore hidden elements in internal feature testing
([natritmeyer])

### Fixed
- Improved the waiting logic for visible / invisible waiters to avoid false failures
([j16r])

## [2.3] - 2013-04-05
### Added
- Initial Dynamic URL support 
  - Adds new dependency to suite `addressable`
  - Allows templating of URL parameters to be passed in as KVP's
([therabidbanana])

- Added Yard Rake task to dynamically generate documentation on gem
([natritmeyer])

## [2.2] - 2013-03-12
### Added
- Added `#parent` and `#parent_page` to `SitePrism::Section` that will find a Sections Parent, and their Parent Page respectively
([dnesteryuk])

- Ruby 1.9 Code cleanup (Hash / gemspec)
([abotalov])

- Travis integration on repository
([abotalov])

### Changed
- Required ruby version now 1.9.3+
([abotalov])

### Fixed
- Various visibility and waiting bug fixes
([dnesteryuk])

## [2.1] - 2013-02-06
### Added
- Added xpath support
([3coins])

- Added `reek` to the suite to try clean up some code-smells
([natritmeyer])

## [2.0] - 2013-01-15
### Added
- Added rake-tasks to suite for `rspec` and `cucumber` tests
([natritmeyer])

### Changed
- Upped Version Dependency of `capybara` to `~> 2.0`
([natritmeyer])

- `site_prism` gem now depends on Ruby 1.9; 1.8 is deprecated (`capybara` no longer supports 1.8)
([natritmeyer])

## [1.4] - 2012-11-20
### Changed
- Changed all references of 'locator' to 'selector' in the code / documentation
([natritmeyer])

- Upped Version Dependencies
  - `capybara ~> 1.1`
  - `rspec ~> 2.0`
  ([natritmeyer])
  
- Internal API Changes:
  - `#element_names` is now `#mapped_items` in `SitePrism::Page` and `SitePrism::Section`
  - We now use a `build` method to decide what methods are created for each element/section and in what order
  ([natritmeyer])

- External API Change (Probably breaking change):
  - `NoLocatorForElement` is now `NoSelectorForElement`
  ([natritmeyer])

### Fixed
- README typo sweep done. Errors fixed
([nathanbain])

## [1.3] - 2012-07-29
### Added
- Added `wait_until_<element_name>_visible` / `wait_until_<element_name>_invisible` for elements and sections
([natritmeyer])

- Added `simplecov` to the suite to give some internal usage statistics
([natritmeyer])

## [1.2] - 2012-07-02
### Added
- Added ability to interact with iFrames
([natritmeyer])

## [1.1.1] - 2012-06-17

### Fixed
- Added ruby 1.8.* support that was broken in [1.1]
([remi])

## [1.1] - 2012-06-14
### Added
- Added `page.secure?` method
([natritmeyer])

## [1.0] - 2012-04-19
- First public release!

### Added
- Added `README.md`
([natritmeyer])

### Fixed
- Fixed issue where cucumber tests wouldn't run due to hardcoded test path
([andyw8])

## [0.9.9] - 2012-03-24
### Added
- Base History document
([natritmeyer])

### Fixed
- Fixed bug where `wait_for_` didn't work in sections
([natritmeyer])

## [0.9.8] - 2012-03-16
### Added
- Added ability to call `execute_javascript` and `evaluate_javascript` inside a `section`
([natritmeyer])

## [0.9.7] - 2012-03-11
### Added
- Added ability to have pending elements, ie: elements declared without locators
([natritmeyer])

## [0.9.6] - 2012-03-06
### Changed
- Refactored parameterised `wait_for_` to accept an overriden wait time
([natritmeyer])

## [0.9.5] - 2012-03-05
### Changed
- Refactored `all_there?` to run faster
([natritmeyer])

## [0.9.4] - 2012-03-01
### Added
- Added `all_there?` method
  - Returns `true` if all mapped elements and sections are present, `false` otherwise
([natritmeyer])

## [0.9.3] - 2012-02-11
### Added
- Added `wait_for_` functionality to pages and sections
([natritmeyer])

## [0.9.2] - 2012-01-11
### Added
- Added ability to access a section's `root_element`
([natritmeyer])

## [0.9.1] - 2012-01-11
### Added
- Added `visible?` to section
([natritmeyer])

## [0.9] - 2011-12-22
- First release!

<!-- Releases -->
[3.0.beta]: https://github.com/natritmeyer/site_prism/compare/v2.17...master
[2.17]: https://github.com/natritmeyer/site_prism/compare/v2.16...2.17
[2.16]:       https://github.com/natritmeyer/site_prism/compare/v2.15.1...v2.16
[2.15.1]:     https://github.com/natritmeyer/site_prism/compare/v2.15...v2.15.1
[2.15]:       https://github.com/natritmeyer/site_prism/compare/v2.14...v2.15
[2.14]:       https://github.com/natritmeyer/site_prism/compare/v2.13...v2.14
[2.13]:       https://github.com/natritmeyer/site_prism/compare/v2.12...v2.13
[2.12]:       https://github.com/natritmeyer/site_prism/compare/v2.11...v2.12
[2.11]:       https://github.com/natritmeyer/site_prism/compare/v2.10...v2.11
[2.10]:       https://github.com/natritmeyer/site_prism/compare/v2.9.1...v2.10
[2.9.1]:      https://github.com/natritmeyer/site_prism/compare/v2.9...v2.9.1
[2.9]:        https://github.com/natritmeyer/site_prism/compare/v2.8...v2.9
[2.8]:        https://github.com/natritmeyer/site_prism/compare/v2.7...v2.8
[2.7]:        https://github.com/natritmeyer/site_prism/compare/v2.6...v2.7
[2.6]:        https://github.com/natritmeyer/site_prism/compare/v2.5...v2.6
[2.5]:        https://github.com/natritmeyer/site_prism/compare/v2.4...v2.5
[2.4]:        https://github.com/natritmeyer/site_prism/compare/v2.3...v2.4
[2.3]:        https://github.com/natritmeyer/site_prism/compare/v2.2...v2.3
[2.2]:        https://github.com/natritmeyer/site_prism/compare/v2.1...v2.2
[2.1]:        https://github.com/natritmeyer/site_prism/compare/v2.0...v2.1
[2.0]:        https://github.com/natritmeyer/site_prism/compare/v1.4...v2.0
[1.4]:        https://github.com/natritmeyer/site_prism/compare/v1.3...v1.4
[1.3]:        https://github.com/natritmeyer/site_prism/compare/v1.2...v1.3
[1.2]:        https://github.com/natritmeyer/site_prism/compare/v1.1.1...v1.2
[1.1.1]:      https://github.com/natritmeyer/site_prism/compare/v1.1...v1.1.1
[1.1]:        https://github.com/natritmeyer/site_prism/compare/v1.0...v1.1
[1.0]:        https://github.com/natritmeyer/site_prism/compare/v0.9.9...v1.0
[0.9.9]:      https://github.com/natritmeyer/site_prism/compare/v0.9.8...v0.9.9
[0.9.8]:      https://github.com/natritmeyer/site_prism/compare/v0.9.7...v0.9.8
[0.9.7]:      https://github.com/natritmeyer/site_prism/compare/v0.9.6...v0.9.7
[0.9.6]:      https://github.com/natritmeyer/site_prism/compare/v0.9.5...v0.9.6
[0.9.5]:      https://github.com/natritmeyer/site_prism/compare/v0.9.4...v0.9.5
[0.9.4]:      https://github.com/natritmeyer/site_prism/compare/v0.9.3...v0.9.4
[0.9.3]:      https://github.com/natritmeyer/site_prism/compare/v0.9.2...v0.9.3
[0.9.2]:      https://github.com/natritmeyer/site_prism/compare/v0.9.1...v0.9.2
[0.9.1]:      https://github.com/natritmeyer/site_prism/compare/v0.9...v0.9.1
[0.9]:        https://github.com/natritmeyer/site_prism/releases/tag/v0.9

<!-- Contributors in chronological order -->
[natritmeyer]:    https://github.com/natritmeyer
[andyw8]:         https://github.com/andyw8
[remi]:           https://github.com/remi
[nathanbain]:     https://github.com/nathanbain
[3coins]:         https://github.com/3coins
[dnesteryuk]:     https://github.com/dnesteryuk
[abotalov]:       https://github.com/abotalov
[therabidbanana]: https://github.com/therabidbanana
[johnwake]:       https://github.com/johnwake
[j16r]:           https://github.com/j16r
[mikekelly]:      https://github.com/mikekelly
[antonio]:        https://github.com/antonio
[LukasMac]:       https://github.com/LukasMac
[tmertens]:       https://github.com/tmertens
[modsognir]:      https://github.com/modsognir
[Mustang949]:     https://github.com/tmertens
[mrsutter]:       https://github.com/mrsutter
[tommyh]:         https://github.com/tommyh
[bassneck]:       https://github.com/bassneck
[soulcutter]:     https://github.com/soulcutter
[KarthikDot]:     https://github.com/KarthikDot
[tgaff]:          https://github.com/tgaff
[petergoldstein]: https://github.com/petergoldstein
[rugginoso]:      https://github.com/rugginoso
[vanburg]:        https://github.com/vanburg
[jonathanchrisp]: https://github.com/jonathanchrisp
[jmileham]:       https://github.com/jmileham
[sponte]:         https://github.com/sponte
[csgavino]:       https://github.com/csgavino
[tpbowden]:       https://github.com/tpbowden
[mnohai-mdsol]:   https://github.com/mnohai-mdsol
[khaidpham]:      https://github.com/khaidpham
[benlovell]:      https://github.com/benlovell
[nitinsurfs]:     https://github.com/nitinsurfs
[cantonic]:       https://github.com/cantonic
[bhaibel]:        https://github.com/bhaibel
[ddzz]:           https://github.com/ddzz
[whoojemaflip]:   https://github.com/whoojemaflip
[tobithiel]:      https://github.com/tobithiel
[luke-hill]:      https://github.com/luke-hill
[RustyNail]:      https://github.com/RustyNail
[iwollmann]:      https://github.com/iwollmann
[TheMetalCode]:   https://github.com/TheMetalCode
[kei2100]:        https://github.com/kei2100
[ricmatsui]:      https://github.com/ricmatsui
[ilyasgaraev]:    https://github.com/ilyasgaraev
[ricmatsui]:      https://github.com/ricmatsui
[robd]:           https://github.com/robd
[ineverov]:       https://github.com/ineverov
[twalpole]:       https://github.com/twalpole
[jgs731]:         https://github.com/jgs731
[mdesantis]:      https://github.com/mdesantis
[JaniJegoroff]:   https://github.com/JaniJegoroff
