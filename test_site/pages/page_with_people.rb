class TestPageWithPeople < Prismatic::Page
  set_url '/page_with_people.htm'
  
  #sections
  section :people_list, People, '.people-something'
end