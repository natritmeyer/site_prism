<!-- #291 - Jul 20th - Last update to this document -->
`2.15.1`
- Initial backwards compatible work for rewriting the Error protocols that will be used in site_prism v3.0 (@luke-hill)
- Altered travis config to test for lowest gem configuration permissible in site_prism (@luke-hill)
- Enabled support for Capybara `< 3.3` (@luke-hill)
- Fix scoping issue that would cause iFrames / JS executors defined inside Sections to be un-callable (@ineverov) 
- Improve runtime of cucumber tests by around 30% overall by tweaking some internal JS code (@luke-hill)
- Amended setup instructions links and doc links that were incorrect (@luke-hill)
- Removed all constants aside from `VERSION` (@luke-hill)
- Add ability to test multiple gemfiles in travis (@luke-hill)
- Fixed up some unit tests to cover pages defined with differing selectors (@luke-hill)

`2.15`
- Add better error message when iFrame's are called without a block (@luke-hill & @mdesantis)
- Fix implicit waiting not working for some DSL defined methods (@luke-hill & @tgaff)
- Added a huge portion of new feature tests to validate timings RE implicit/explicit waits (@tgaff)
- Enabled support for Capybara `< 3.1`. Making sure suite is backwards compatible (@luke-hill)
- Added more gem metadata into the `.gemspec` file to be read by RubyGems (@luke-hill)
- Fixed up majority of remaining Rubocop offenses around the suite (@ineverov)

`2.14`
- Added positive and negative timing tests to several scenarios in `waiting.feature` (@luke-hill)
- Rewrite `ElementContainer` by using `klass.extend`, drying up the amount of `self.class` calls (@ineverov) 
- Remove `private` definitions that are in-lined (@jgs731)
- Partially fixed up `LineLength` offenses around the entire suite (@ineverov)
- Updated gemspec to allow latest `selenium-webdriver` gem in development. Enables `rubocop` up to V55 (@luke-hill)
- Tidied up specs and made Code Coverage 100% compliant (@luke-hill)
- Fixed issue where multiple search arguments weren't being set and ignored by Capybara (@twalpole)
- Removed references to `Timeout.timeout` as this isn't threadsafe (@twalpole)
- Enabled ability to set default search arguments inside a Section (@ineverov)
  - If set then a section will set the `root_element` to be whatever is defined using `set_default_search_arguments`
  - If unset / overridden. You are able to still define them in-line using the DSL in the regular manner
- Introduced new sister method to `#expected_elements`. `#elements_present` will return an Array of every Element that is present on the Page/Section (@luke-hill)
- Fixed waiting bug that caused `Waiter.default_wait_time` not to wait the correct duration when implicit waits were toggled (@luke-hill)

`2.13`
- Cleanup cucumber tests into more granular structure (@luke-hill)
- Use `shared_examples` in RSpec tests to enhance coverage and check xpath selectors (@luke-hill))
- Introduced configuration to raise an Exception after `wait_for` meta-programmed methods fail to find pass (@ricmatsui)
- Altered output of RSpec to show test names, and unlock testing on Selenium up to v3.10 (@luke-hill)
- Upgraded Cucumber to `3.0.1` (Allowing new syntax testing) (@luke-hill)
- Added Feature to wait for non-existence of element/section (@ricmatsui)
- Updated Travis to test on Ruby `2.5`. Removed testing for Ruby `2.0` (@luke-hill)
- Updated Suite Ruby Requirements (**Minimum Ruby is now `2.1`**) (@luke-hill)
- Refactored Waiter Class (cleaner `.wait_until_true`, deprecated `.default_wait_time`) (@luke-hill)
- Added new development docs to aid new and existing contributors (@luke-hill)

`2.12`
- Performed a suite-wide cleanup of Gherkin. Made everything a lot more organised (@luke-hill)
- Expose the `#native` method on Section Objects (@luke-hill)
- Fix issue where within a section, we lose our scoping due to leveraging the full `Capybara::DSL` - So we need to re-scope our `page` object to be our new `root_element` (@ilyasgaraev)
- Unlock testing on Selenium up to v3.8 (@luke-hill)
- Fix suite incidentally masking several issues due to incorrect cucumber setup (@luke-hill)
- Allow iFrames to be specified using several new types of selector (ID / Class / XPath / Index) (@ricmatsui)
- Generic SitePrism cleanup (Improved Test Coverage, Updated Dependencies, Cleared out some TODO tasks) (@luke-hill)
- Update Travis Environment to now test on Chrome and Firefox (@RustyNail & @luke-hill)
- Increase testing coverage of framework to include Ruby 2.4 (@luke-hill)

`2.11`
- Refactor Addressable library so its slightly less confusing to debug - still in progress! (@luke-hill)
- Update Travis to test on a variety of rubies: `2.0 -> 2.3`, and using the latest geckodriver (@luke-hill)
- Improved Documentation around rubies (@luke-hill)
- Compressed `Rakefile` into smaller shell tasks for Increased Verbosity on Failures and execution time (@luke-hill)
- Allow `all_there?` to be extended in the DSL with `expected_elements`. Allowing pages with the correct number of sections/elements to be easily tested (@TheMetalCode)
- Fix bug where SitePrism failed load-validation's when being passed Block Parameters without URL's (@kei2100)
- Use the `.gemspec` file for all versioning needs and remove any references to gems in the Gemfile (@luke-hill & @tgaff)
- Re-enable Rubocop compliance from PR signoff (Including fixing up some offences) (@RustyNail)

`2.10`
- Established Roadmap of items to be fixed in coming months (@luke-hill)
- Fixed a bug on documentation around `section` example (@iwollmann & @luke-hill)
- Reworked specs / developmental code to read better and perform slightly better (@luke-hill)
- Added base contributing / issue templates (@luke-hill)
- Allow `#all_there?` to use in-line configured implicit wait (Still defaulted to not use waits) (@RustyNail)
- Disable Rubocop compliance from PR signoff whilst suite is still being reworked (To be switched back on for `2.11` gem cut) (@luke-hill)
- Upped Version Dependencies (@luke-hill)
  - `capybara ~> 2.3`
  - `rspec ~> 3.2`
  - Required Ruby Version is now 2.0+
- Fix Travis not pulling in geckodriver dependency (And also bump Ubuntu container) (@RustyNail)
- Additional rubocop tweaks to bring suite back under rubocop control (@luke-hill)
- Cap `cucumber` and `selenium-webdriver` dev dependencies (Whilst suite is being reworked as an interim measure) (@luke-hill)
- Rework all text files into Markdown structure, improve formatting (@luke-hill)

`v2.9.1`
- Improved Codecoverage pass-rate from `85%` to `99%` (1 outstanding item) (@luke-hill)
- Codebase cleanup of non-used config files (@luke-hill)
- Bumped Travis Ruby version from `2.2` to `2.3`
- Rubocop tweaks in line with updated Community style updates
- Fixed clash with rspec (@tobithiel)

`v2.9`
- Fix a Section Element calling `#text` incorrectly returning the full page text - thanks to @ddzz
- Added ability to use block syntax inside spec / test sections (@tgaff)
- Implement new Loadable behavior for pages and sections - thanks to @tmertens

## [X.X] - 2015-05-XX
### Removed
N/A

### Added
N/A

### Changed
N/A

### Fixed
N/A

## [2.9] - 2016-03-29
### Removed
N/A

### Added
N/A

### Changed
N/A

### Fixed
N/A

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
[Unreleased]: https://github.com/natritmeyer/site_prism/compare/v2.15.1...master

<!-- all up to 2.8 correctly formatted and datestamped -->
<!-- all releases up to 2.8 correctly checked for content / people -->
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



[luke-hill]:      https://github.com/luke-hill