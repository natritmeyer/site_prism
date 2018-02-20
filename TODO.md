To Update:
1) Capybara 2.1+ compatibility - iFrame stuff
(Need to update `Capybara` restrictions to something less old!)

_This needs updating to at least 2.6+_ (Inline with last cut of SP development)

2) Generic Update of dependencies
3) Documentation of supported rubies

To Re-Triage:
1) `SitePrism::Page#wait_until_displayed`
2) Anonymous sections

To be worked on now:
1) Coverage of the following files (Only a small amount of code changes required)
`features/step_definitions/page_section_steps.rb` `95.7 %`
`spec/page_spec.rb`	`98.04 %`
`spec/loadable_spec.rb`	`99.06 %`
`features/step_definitions/iframe_steps.rb`	`99.9 %`
2) Figure out why the loadable spec isn't playing nicely.
One line to tidy up for full codecoverage compliance
