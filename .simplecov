# frozen_string_literal: true

SimpleCov.start do
  add_group 'Features', 'features'
  add_group 'Specs', 'spec'
  add_group 'Code', 'lib'
end

SimpleCov.minimum_coverage 97
