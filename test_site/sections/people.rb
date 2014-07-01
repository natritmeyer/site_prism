# encoding: utf-8

class People < SitePrism::Section
  element :title, '.people-title'
  element :dinosaur, '.dinosaur' # doesn't exist on the page

  elements :individuals, '.person'
end
