<!-- `#206 last Update to this document` -->

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

`v2.8`
- Catching up with Capybara's `#default_max_wait_time` (@tpbowden, @mnohai-mdsol & @tmertens)
- Simplified check for URI scheme (@benlovell)

`v2.7`
- Spring clean of the code - thanks to Jonathan Chrisp (@jonathanchrisp)
- Fixes around Capybara's `#title` method - thanks to @tgaff
- Changes around url matching - thanks to @jmileham
- Added check for block being passed to page - thanks to @sponte

`v2.6`
- Added rspec 3 compatibility - thanks to Bradley Schaefer (@soulcutter)
- Added anonymous sections - thanks to Constantine Zaytsev (@bassneck)

`v2.5`
- Added ability to select iFrame by index - thanks to Mike Kelly (@mikekelly)
- `site_prism` gem now does lazy loading - thanks to @mrsutter
- Added config block and improved `capybara` integration - thanks to @tmertens (and to @LukasMac for testing it)
- Changed `#set_url` to convert its input to a string - thanks to Jared Fraser (@modsognir)

`v2.4`
- Upped Version Dependency of capybara to `2.1`
- `SitePrism::Page#title` now returns `""` instead of `nil` when there is no title
- Added `#has_no_<element>?` - thanks to John Wakeling (@johnwake)
- `site_prism` now uses `Capybara::Node::Finders#find` instead of `#first` to locate individual elements

`v2.3`
- Dynamic URLs - thanks to David Haslem (@therabidbanana)

`v2.2`
- Added `#parent` and `#parent_page` to `SitePrism::Section` - thanks to Dmitriy Nesteryuk (@nestd)
- Various bug fixes - thanks to Dmitriy Nesteryuk (@nestd)
- General code cleanup (including Travis integration) - thanks to Andrey Botalov (@abotalov)
- Required ruby version now 1.9.3+

`v2.1`
- Added xpath support - thanks to Piyush Jain (@3coins)

`v2.0`
- Upped Version Dependency of `capybara` to `2.0`
- `site_prism` gem now depends on Ruby 1.9; 1.8 is deprecated (`capybara` no longer supports 1.8)

`v1.4`
- Changed all occurrences of 'locator' to 'selector' in the code
- Upped Version Dependencies
  - `capybara ~> 1.1`
  - `rspec ~> 2.0`
- API Changes:
  - API change: `NoLocatorForElement` is now `NoSelectorForElement`
  - Renamed `#element_names` to `#mapped_items` for `SitePrism::Page` and `SitePrism::Section`

`v1.3`
- Added `wait_until_<element_name>_visible` / `wait_until_<element_name>_invisible` for elements and sections

`v1.2`
- Added ability to interact with iFrames

`v1.1.1`
- Added ruby 1.8.* support

`v1.1`
- Added `page.secure?` method

`v1.0`
- Added `README.md`
- First public release

`v0.9.9`
- Fixed bug where `wait_for_` didn't work in sections

`v0.9.8`
- Added ability to call `execute_javascript` and `evaluate_javascript` inside a `section`

`v0.9.7`
- Added ability to have pending elements, ie: elements declared without locators

`v0.9.6`
- Added parameterised `wait_for_`

`v0.9.5`
- Refactoring `all_there?`

`v0.9.4`
- Added `all_there?` method - Returns `true` if all mapped elements and sections are present, `false` otherwise

`v0.9.3`
- Added `wait_for_` functionality to pages and sections

`v0.9.2`
- Added ability to access a section's `root_element`

`v0.9.1`
- Added `visible?` to section

`v0.9`
- First release!
