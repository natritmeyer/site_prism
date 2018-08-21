# Upgrading from SitePrism 2.x to 3.x

## Default Load Validations

SitePrism 2.x contains 1 inbuilt load validation for any Page that is a direct descendant of `SitePrism::Page`.
This has now been removed. If you wish to retain the previous functionality, add the following load validation

```ruby
class MyPage < SitePrism::Page
end
```

now becomes ...

```ruby
class MyPage < SitePrism::Page
  load_validation { [displayed?, "Expected #{current_url} to match #{url_matcher} but it did not."] }
end
```

You can also create a `BasePage` class if you want to retain this functionality globally
```ruby
class BasePage < SitePrism::Page
   load_validation { [displayed?, "Expected #{current_url} to match #{url_matcher} but it did not."] }
end
```

And then you just need to have ...

```ruby
class MyPage < BasePage
end
```

## Error Classes

A reasonably large change, but one that made sense to do in a major bump was a rewrite of the error names.

Each Error Class has been restructured and renamed. Check `error.rb` for previous names.

## Configuration Options

Previously `site_prism` (As of `2.15.1`), had 3 configuration options, these were (With defaults) ...

```ruby
  default_load_validations = true #=> Whether the default load validation for displayed? was set 
  use_implicit_waits = false #=> Whether site_prism would use Capybara's implicit waiting by default
  raise_on_wait_fors = false #=> Whether running wait_for_<element/section> methods that failed would crash
```

Now the only option which remains is `use_implicit_waits`. The other two have been removed.
