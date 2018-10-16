# frozen_string_literal: true

Then('I can see a collection of sections') do
  results = @test_site.nested_sections.search_results
  results.each_with_index do |search_result, index|
    expect(search_result.title.text).to eq("title #{index}")

    expect(search_result.description.text).to eq("description #{index}")
  end

  expect(@test_site.nested_sections.search_results.size).to eq(4)
end

Then('I can see a collection of anonymous sections') do
  sections = @test_site.nested_sections.anonymous_sections
  sections.each_with_index do |section, index|
    expect(section.title.text).to eq("Section #{index}")
  end

  expect(@test_site.nested_sections.anonymous_sections.size).to eq(2)
end
