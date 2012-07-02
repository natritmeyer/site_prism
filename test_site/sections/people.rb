class People < SitePrism::Section
  element :title, '.people-title'

  elements :individuals, '.person'
end

