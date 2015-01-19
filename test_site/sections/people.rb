class People < SitePrism::Section
  element :headline, 'h1'
  element :dinosaur, '.dinosaur' # doesn't exist on the page

  elements :individuals, '.person'
end
