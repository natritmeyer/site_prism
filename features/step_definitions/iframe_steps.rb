# frozen_string_literal: true

Then('I can locate the iframe by id') do
  @test_site.home.wait_for_my_iframe

  expect(@test_site.home).to have_my_iframe
end

Then('I can locate the iframe by index') do
  @test_site.home.wait_for_index_iframe

  expect(@test_site.home).to have_index_iframe
end

Then('I can locate the iframe by name') do
  @test_site.home.wait_for_named_iframe

  expect(@test_site.home).to have_named_iframe
end

Then('I can locate the iframe by xpath') do
  @test_site.home.wait_for_xpath_iframe

  expect(@test_site.home).to have_xpath_iframe
end

Then('I can locate the iframe within section') do
  @test_site.home.wait_for_section_for_iframe
  @test_site.home.section_for_iframe.wait_for_iframe_within_section

  expect(@test_site.home.section_for_iframe).to have_iframe_within_section
end

Then('I can see elements in an iframe') do
  @test_site.home.my_iframe do |f|
    expect(f.some_text.text).to eq('Some text in an iframe')
  end
end

Then('I can see elements in an indexed iframe') do
  @test_site.home.index_iframe do |f|
    expect(f.some_text.text).to eq('Some text in an iframe')
  end
end

Then('I can see elements in a named iframe') do
  @test_site.home.named_iframe do |f|
    expect(f.some_text.text).to eq('Some text in an iframe')
  end
end

Then('I can see elements in an xpath iframe') do
  @test_site.home.xpath_iframe do |f|
    expect(f.some_text.text).to eq('Some text in an iframe')
  end
end

Then('I can see elements in the iframe within section') do
  @test_site.home.section_for_iframe.iframe_within_section do |f|
    expect(f.some_text.text).to eq('Some text in an iframe')
  end
end

Then('I can see elements in an iframe with capybara query options') do
  @test_site.home.my_iframe do |f|
    expect(f).to have_some_text(text: 'Some text in an iframe')
  end
end

Then('I cannot interact with an iFrame outside of a block') do
  error_message = 'You can only use iFrames in a block context. See docs for more details.'

  expect { @test_site.home.my_iframe }
    .to raise_error(SitePrism::BlockMissingError)
    .with_message(error_message)
end
