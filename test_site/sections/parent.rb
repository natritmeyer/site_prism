class Parent < Prismatic::Section
  section :child_section, Child, '.child-div'
end