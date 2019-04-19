# frozen_string_literal: true

When('I navigate to the home page') do
  @test_site.home.load
end

When('I navigate to the letter A page') do
  @test_site.dynamic.load(letter: 'a')
end

When('I navigate to the redirect page') do
  @test_site.redirect.load
end

When('I navigate to a page with no title') do
  @test_site.no_title.load
end

When('I navigate to the nested section page') do
  @test_site.nested_sections.load
end

When('I navigate to the slow page') do
  @test_site.slow.load
end

When('I navigate to the vanishing page') do
  @test_site.vanishing.load
end

Then('I am on the home page') do
  expect(@test_site.home).to be_displayed
end

Then('I am on a dynamic page') do
  expect(@test_site.dynamic).to be_displayed
end

Then('I am on the redirect page') do
  expect(@test_site.redirect).to be_displayed
end

Then('I am not on the redirect page') do
  expect(@test_site.redirect).not_to be_displayed
end

Then('I will be redirected to the home page') do
  expect(@test_site.home).to be_displayed
end

Then('I will be redirected to the page without a title') do
  expect(@test_site.no_title).to be_displayed
end

When('I click the go button') do
  @test_site.home.go_button.click
end

When('I navigate a page with no load validations') do
  start_time = Time.now
  @test_site.home.load
  @duration = Time.now - start_time
end

When('I navigate a page with load validations') do
  start_time = Time.now
  @test_site.delayed.load
  @duration = Time.now - start_time
end

When('an error is thrown when loading a page with failing validations') do
  expect { @test_site.crash.load }
    .to raise_error(SitePrism::FailedLoadValidationError)
end

Then('I am not made to wait to continue') do
  expect(@duration).to be < 0.1
end

Then('I am made to wait to continue') do
  expect(@duration).to be > 0.2
end

Then('the page will not be marked as loaded') do
  expect(@test_site.crash).not_to be_loaded
end

When('no error is thrown when loading a page') do
  expect { @test_site.crash.load }
    .not_to raise_error(SitePrism::FailedLoadValidationError)
end

Then('the page will be marked as loaded') do
  expect(@test_site.crash).to be_loaded
end
