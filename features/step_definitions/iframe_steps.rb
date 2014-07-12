Then /^I can locate the iframe by id$/ do
  @test_site.home.wait_for_my_iframe
  expect(@test_site.home).to have_my_iframe
end

Then /^I can locate the iframe by index$/ do
  @test_site.home.wait_for_index_iframe
  expect(@test_site.home).to have_index_iframe
end

Then /^I can see elements in an iframe$/ do
  @test_site.home.my_iframe do |f|
    expect(f.some_text.text).to eq "Some text in an iframe"
  end
end

Then /^I can see elements in an iframe with capybara query options$/ do
  @test_site.home.my_iframe do |f|
    expect(f).to have_some_text :text => "Some text in an iframe"
  end
end

