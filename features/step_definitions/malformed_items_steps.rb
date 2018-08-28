# frozen_string_literal: true

Then('an exception is raised when I deal with an element with no selector') do
  expect { @test_site.no_title.has_element_without_selector? }
    .to raise_error(SitePrism::InvalidElementError)
    .with_message(/element_without_selector/)
  expect { @test_site.no_title.element_without_selector }
    .to raise_error(SitePrism::InvalidElementError)
    .with_message(/element_without_selector/)
  expect { @test_site.no_title.wait_until_element_without_selector_visible }
    .to raise_error(SitePrism::InvalidElementError)
    .with_message(/element_without_selector/)
end

Then('an exception is raised when I deal with elements with no selector') do
  expect { @test_site.no_title.has_elements_without_selector? }
    .to raise_error(SitePrism::InvalidElementError)
    .with_message(/elements_without_selector/)
  expect { @test_site.no_title.elements_without_selector }
    .to raise_error(SitePrism::InvalidElementError)
    .with_message(/elements_without_selector/)
  expect { @test_site.no_title.wait_until_elements_without_selector_visible }
    .to raise_error(SitePrism::InvalidElementError)
    .with_message(/elements_without_selector/)
end
