# frozen_string_literal: true

class TestSite
  def home
    @home ||= Home.new
  end

  def home_with_expected_elements
    TestHomePageWithExpectedElements.new
  end

  def no_title
    @no_title ||= NoTitle.new
  end

  def dynamic_page
    @dynamic_page ||= DynamicPage.new
  end

  def redirect_page
    @redirect_page ||= RedirectPage.new
  end

  def section_experiments
    @section_experiments ||= SectionExperiments.new
  end
end
