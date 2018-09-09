# frozen_string_literal: true

Then('I can see a collection of sections') do
  results = @test_site.section_experiments.search_results
  results.each_with_index do |search_result, index|
    expect(search_result.title.text).to eq("title #{index}")

    expect(search_result.description.text).to eq("description #{index}")
  end

  expect(@test_site.section_experiments.search_results.size).to eq(4)
end

Then('I can see a collection of anonymous sections') do
  sections = @test_site.section_experiments.anonymous_sections
  sections.each_with_index do |section, index|
    expect(section.title.text).to eq("Section #{index}")
  end

  expect(@test_site.section_experiments.anonymous_sections.size).to eq(2)
end

Then('all expected elements are present in the search results') do
  expect(@test_site.section_experiments.search_results.first).to be_all_there
end
