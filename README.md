# SitePrism
_A Page Object Model DSL for Capybara_

SitePrism gives you a simple, clean and semantic DSL for describing your site using the Page Object Model pattern, for use with Capybara in automated acceptance testing. It encourages the "Page Object Model" pattern and makes it easy to do it well. One of its aims is to provide a pleasant syntax when using rspec/cucumber matchers and expectations.

## Setup

### Installation

To install SitePrism:

```bash
gem install site_prism
```

### Using SitePrism with Cucumber

If you are using cucumber, here's what needs requiring:

```ruby
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
```

### Using SitePrism with RSpec

If you're using rspec instead, here's what needs requiring:

```ruby
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
```

## Introduction to the Page Object Model

The Page Object Model is a test automation pattern that aims to create
an abstraction of your site's user interface that can be used in tests.
The most common way to do this is to model each page as a class, and
to then use instances of those classes in your tests.

If a class represents a page then each element of the page is
represented by a method that, when called, returns a reference to that
element that can then be acted upon (clicked, set text value), or
queried (is it enabled? visible?).

SitePrism is based around this concept, but goes further as you'll see
below by also allowing modelling of repeated sections that appear on
muliple pages, or many times on a page using the concept of sections.

## Pages

As you might be able to guess from the name, pages are fairly central to
the Page Object Model. Here's how SitePrism models them:

### Creating a Page Model

The simplest page is one that has nothing defined in it. Here's an
example of how to begin modelling a home page:

```ruby
class Home < SitePrism::Page
end
```

The above has nothing useful defined, only the name.

### Adding a URL

A page usually has a URL. If you want to be able to navigate to a page,
you'll need to set its URL. Here's how:

```ruby
class Home < SitePrism::Page
  set_url "http://www.google.com"
end
```

Note that setting a URL is optional - you only need to set a url if you want to be able to navigate
directly to that page. It makes sense to set the URL for a page model of a home
page or a login page, but not a search results page.

### Navigating to the Page

Once the URL has been set (using `set_url`), you can navigate directly
to the page using `#load`:

```ruby
@home_page = Home.new
@home_page.load
```

This will tell which ever capybara driver you have configured to
navigate to the URL set against that page's class.

### Verifying that a particular page is displayed

Automated tests often need to verify that a particular page is
displayed. Intuitively you'd think that simply checking that the URL
defined using `set_url` would be enough, but experience shows that it's
not. It is far more robust to check to see if the browser's current url
matches a regular expression. For example, though `account/1` and `account/2`
display the same page, their URLs are different. To deal with this,
SitePrism provides the ability to set a URL matcher.

```ruby
class Account < SitePrism::Page
  set_url_matcher /\account\/\d+/
end
```

Once a URL matcher is set for a page, you can test to see if it is
displayed:

```ruby
@account_page = Account.new
#...
@account_page.displayed? #=> true or false
```

Calling `#displayed?` will return true if the browser's current URL
matches the regular expression for the page and false if it doesn't.

#### Testing for Page display

SitePrism's `#displayed?` predicate method allows for semantic code in
your test:

```ruby
Then /^the account page is displayed$/ do
  @account_page.should be_displayed
  @some_other_page.should_not be_displayed
end
```

Another example that demonstrates why using regex instead of string
comparison for URL checking is when you want to be able to run your
tests across multiple environments.

```ruby
class Login < SitePrism::Page
  set_url "#{$test_environment}.example.com/login" #=> global var used for demonstration purposes only!!!
  set_url_matcher /(?:dev|test|www)\.example\.com\/login/
end
```

The above example would work for `dev.example.com/login`,
`test.example.com/login` and `www.example.com/login`; now your tests
aren't limited to one environment but can verify that they are on the
correct page regardless of the environment the tests are being executed
against.

#### Page Title

Getting a page's title isn't hard:

```ruby
class Account < SitePrism::Page
end

@account = Account.new
#...
@account.title #=> "Welcome to Your Account"
```

## Elements

Pages are made up of elements (text fields, buttons, combo boxes, etc),
either individual elements or groups of them. Examples of individual
elements would be a search field or a company logo image; examples of
element collections would be items in any sort of list, eg: menu items,
images in a carousel, etc.

### Individual Elements

To interact with individual elements, they need to be defined as part of
the relevant page. SitePrism makes this easy:

```ruby
class Home < SitePrism::Page
  element :search_field, "input[name='q']"
end
```

Here we're adding a search field to the Home page. The `element` method
takes 2 arguments: the name of the element as a symbol, and a css locator
as a string.

#### Accessing the individual element

The `element` method will add a number of methods to instances of the
particular Page class. The first method to be added is the name of the
element. So using the following example:

```ruby
class Home < SitePrism::Page
  set_url "http://www.google.com"

  element :search_field, "input[name='q']"
end
```

... the following shows how to get hold of the search field:

```ruby
@home_page = Home.new
@home.load

@home.search_field #=> will return the capybara element found using the locator
@home.search_field.set "the search string" #=> since search_field returns a capybara element, you can use the capybara API to deal with it
```

#### Testing for the existence of the element

Another method added to the Page class by the `element` method is the
`has_<element name>?` method. Using the same example as above:

```ruby
class Home < SitePrism::Page
  set_url "http://www.google.com"

  element :search_field, "input[name='q']"
end
```

... you can test for the existence of the element on the page like this:

```ruby
@home_page = Home.new
@home.load
@home.has_search_field? #=> returns true if it exists, false if it doesn't
```

...which makes for nice test code:

```ruby
Then /^the search field exists$/ do
  @home.should have_search_field
end
```

### Element Collections



# This README.md file is a work in progress. It should be finished soon...

