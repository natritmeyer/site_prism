# frozen_string_literal: true

Then('I can get the text values for the group of links') do
  expect(@test_site.home.lots_of_links.map(&:text)).to eq(%w[a b c])
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
  expect { @test_site.home.wait_for_lots_of_links(1.6, minimum: 1) }
    .not_to raise_error
end
