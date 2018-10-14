# frozen_string_literal: true

class Top < SitePrism::Section
  section :middle, '.middle-div' do
    element :bottom, '.bottom-div'
  end
end
