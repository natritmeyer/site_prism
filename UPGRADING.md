# Upgrading from SitePrism 2.x to 3.x

## Default Load Validations

SitePrism 2.x contains 1 inbuilt load validation for any Page that is a
direct descendant of `SitePrism::Page`. This has now been removed.
If you wish to retain the previous functionality then ...

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

You can also create a `BasePage` class if you want to retain this functionality
across all your Pages

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

The entire set of error names have been re-written.
Check [error.rb](https://github.com/natritmeyer/site_prism/blob/master/lib/site_prism/error.rb)
for previous names.

## Configuration Options

Previously `site_prism` (As of `2.17.1`), had 3 configuration options. These were ...

```ruby
  default_load_validations = true #=> Whether the default load validation for displayed? was set 
  use_implicit_waits = false #=> Whether site_prism would use Capybara's implicit waiting by default
  raise_on_wait_fors = false #=> Whether running wait_for_<element/section> methods that failed would crash
```

These have all been removed with the `3.0` release. Implicit Waiting is
controlled / modifiable either in-line for each method-call, or you can set the default
timeout by re-configuring `Capybara.default_max_wait_time`.


## `wait_until` methods

Previously `wait_until` methods accepted a numerical value for wait time.  The wait time should now be passed using hash args like: `wait: <seconds>`

For example, previously:

```rb
@page.wait_until_dialog_invisible(10)
@page.wait_until_notification_flag_visible(5, count: 3)
```

These now become:

```rb
@page.wait_until_dialog_invisible(wait: 10)
@page.wait_until_notification_flag_visible(wait: 5, count: 3)
```

> Note: If after upgrading you see `Unused parameters passed to Capybara::Queries::SelectorQuery : [NUMBER]` this may indicate that you need to make this change.