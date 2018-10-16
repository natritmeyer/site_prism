# frozen_string_literal: true

class TestSite
  def home
    @home ||= Home.new
  end

  def no_title
    @no_title ||= NoTitle.new
  end

  def dynamic_page
    @dynamic_page ||= DynamicPage.new
  end

  def redirect
    @redirect ||= Redirect.new
  end

  def nested_sections
    @nested_sections ||= NestedSections.new
  end

  def slow
    @slow ||= Slow.new
  end

  def vanishing
    @vanishing ||= Vanishing.new
  end
end
