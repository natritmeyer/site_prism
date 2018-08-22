# frozen_string_literal: true

Then('I can get the text values for the group of links') do
  expect(@test_site.home.removing_links.map(&:text)).to eq(%w[a b c])
end

Then('the page does not have a group of elements') do
  expect(@test_site.home.has_no_nonexistent_elements?).to be true

  expect(@test_site.home).to have_no_nonexistent_elements
end

Then('I can see individual people in the people list') do
  expect(@test_site.home.people.individuals.size).to eq(4)

  expect(@test_site.home.people).to have_individuals(count: 4)
end

Then('I can see optioned individual people in the people list') do
  expect(@test_site.home.people.optioned_individuals.size).to eq(4)

  expect(@test_site.home.people).to have_optioned_individuals(count: 4)
end

Then('I can wait a variable time and pass query parameters') do
  expect { @test_site.home.wait_for_rows(1.6, minimum: 1) }.not_to raise_error
end

Then("waiting a short time for elements to disappear doesn't raise an error") do
  expect do
    @test_site.home.wait_for_no_removing_links(0.1, text: 'wibble')
  end.not_to raise_error
end
