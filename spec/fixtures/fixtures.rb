# frozen_string_literal: true

class Blank < SitePrism::Section; end

module ItemStubs
  # Add every item here you want to return true from has_<item>?
  def present_stubs
    %i[bob success_msg]
  end

  def there?(element)
    present_stubs.include?(element)
  end
end
