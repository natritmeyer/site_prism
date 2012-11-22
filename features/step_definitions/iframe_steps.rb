Then /^I can see an iframe$/ do
  @test_site.home.should have_my_iframe
end

Then /^I can see elements in an iframe$/ do
  @test_site.home.my_iframe do |f|
    f.some_text.text.should == "Some text in an iframe"
  end
end

