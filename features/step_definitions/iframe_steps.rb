Then /^I can locate the iframe by id$/ do
  @test_site.home.wait_for_my_iframe
  @test_site.home.should have_my_iframe
end

Then /^I can locate the iframe by index$/ do
  @test_site.home.wait_for_index_iframe
  @test_site.home.should have_index_iframe
end

Then /^I can see elements in an iframe$/ do
  @test_site.home.my_iframe do |f|
    f.some_text.text.should == "Some text in an iframe"
  end
end

