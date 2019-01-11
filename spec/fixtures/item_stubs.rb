# frozen_string_literal: true

module ItemStubs
  # Add every item here you want to return true when calling #all_there?
  def present_stubs
    %i[
      element_one
      element_three
    ]
  end

  def there?(element)
    present_stubs.include?(element)
  end
end
