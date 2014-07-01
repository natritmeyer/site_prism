# encoding: utf-8

class TestPageWithPeople < SitePrism::Page
  set_url '/page_with_people.htm'

  # sections
  section :people_list, People, '.people-something'
end
