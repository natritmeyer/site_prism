# frozen_string_literal: true

Then('an exception is raised when I deal with an element with no selector') do
  expect { @test_site.no_title.has_element_without_selector? }
    .to raise_error(SitePrism::NoSelectorForElement)
  expect { @test_site.no_title.element_without_selector }
    .to raise_error(SitePrism::NoSelectorForElement)
  expect { @test_site.no_title.wait_for_element_without_selector }
    .to raise_error(SitePrism::NoSelectorForElement)
end

Then('an exception is raised when I deal with elements with no selector') do
  expect { @test_site.no_title.has_elements_without_selector? }
    .to raise_error(SitePrism::NoSelectorForElement)
  expect { @test_site.no_title.elements_without_selector }
    .to raise_error(SitePrism::NoSelectorForElement)
  expect { @test_site.no_title.wait_for_elements_without_selector }
    .to raise_error(SitePrism::NoSelectorForElement)
end
