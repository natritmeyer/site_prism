# frozen_string_literal: true

Then('the slow element is waited for') do
  start_time = Time.now
  @test_site.slow.last_link

  expect(Time.now - start_time).to be_between(0.15, 0.3)
end

Then('the slow elements are waited for') do
  start_time = Time.now
  @test_site.slow.even_links

  expect(Time.now - start_time).to be_between(0.15, 0.3)
end

Then('the slow section is waited for') do
  start_time = Time.now
  @test_site.slow.first_section

  expect(Time.now - start_time).to be_between(0.15, 0.3)
end

Then('the slow sections are waited for') do
  start_time = Time.now
  @test_site.slow.all_sections(count: 2)

  expect(Time.now - start_time).to be_between(0.15, 0.3)
end

Then('the boolean test for a slow element is waited for') do
  start_time = Time.now

  expect(@test_site.slow.has_last_link?).to be true

  expect(Time.now - start_time).to be_between(0.15, 0.3)
end

Then('the boolean test for slow elements are waited for') do
  start_time = Time.now

  expect(@test_site.slow.has_even_links?).to be true

  expect(Time.now - start_time).to be_between(0.15, 0.3)
end

Then('the boolean test for a slow section is waited for') do
  start_time = Time.now

  expect(@test_site.slow.has_first_section?).to be true

  expect(Time.now - start_time).to be_between(0.15, 0.3)
end

Then('the boolean test for slow sections are waited for') do
  start_time = Time.now

  expect(@test_site.slow.has_all_sections?(count: 2)).to be true

  expect(Time.now - start_time).to be_between(0.15, 0.3)
end
