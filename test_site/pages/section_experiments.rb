class TestSectionExperiments < Prismatic::Page
  set_url '/section_experiments.htm'
  
  section :parent_section, Parent, '.parent-div'
end