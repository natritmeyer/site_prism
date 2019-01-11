# frozen_string_literal: true

class People < SitePrism::Section
  set_default_search_arguments '.people'

  element :headline, 'h2'
  element :not_here, '.dinosaur'

  elements :individuals, '.person'
  elements :optioned_individuals, 'span', class: 'person'
end
