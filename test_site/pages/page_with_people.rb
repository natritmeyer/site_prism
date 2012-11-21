class TestPageWithPeople < SitePrism::Page
  set_url "file://" + Dir.pwd + "/test_site/html/page_with_people.htm"

  #sections
  section :people_list, People, '.people-something'
end

