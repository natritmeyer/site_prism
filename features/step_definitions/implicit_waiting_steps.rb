# frozen_string_literal: true

Then('the slow element is waited for') do
  start_time = Time.now
  @test_site.home.slow_element

  expect(Time.now - start_time).to be_between(1, 1.3)
end

Then('the slow elements are waited for') do
  start_time = Time.now
  @test_site.home.slow_elements(count: 1)

  expect(Time.now - start_time).to be_between(1, 1.3)
end

Then('the slow section is waited for') do
  start_time = Time.now
  @test_site.home.slow_section(count: 1)

  expect(Time.now - start_time).to be_between(1, 1.3)
end

Then('the slow sections are waited for') do
  start_time = Time.now
  @test_site.home.slow_sections(count: 2)

  expect(Time.now - start_time).to be_between(1, 1.3)
end

Then('the boolean test for a slow element is waited for') do
  start_time = Time.now

  expect(@test_site.home.has_slow_element?).to be true

  expect(Time.now - start_time).to be_between(1, 1.3)
end

Then('the boolean test for slow elements are waited for') do
  start_time = Time.now

  expect(@test_site.home.has_slow_elements?).to be true

  expect(Time.now - start_time).to be_between(1, 1.3)
end

Then('the boolean test for a slow section is waited for') do
  start_time = Time.now

  expect(@test_site.home.has_slow_section?(count: 1)).to be true

  expect(Time.now - start_time).to be_between(1, 1.3)
end

Then('the boolean test for slow sections are waited for') do
  start_time = Time.now

  expect(@test_site.home.has_slow_sections?(count: 2)).to be true

  expect(Time.now - start_time).to be_between(1, 1.3)
end
