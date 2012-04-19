# SitePrism
_A Page Object Model DSL for Capybara_

SitePrism gives you a simple, clean and semantic DSL for describing your site using the Page Object Model pattern, for use with Capybara in automated acceptance testing. It encourages the "Page Object Model" pattern and makes it easy to do it well. One of its aims is to provide a pleasant syntax when using rspec/cucumber matchers and expectations.

## Synopsis

Here's an overview of how SitePrism is designed to be used:

```ruby
# define our site's pages

class Home < SitePrism::Page
  set_url "http://www.google.com"
  set_url_matcher /google.com\/?/

  element :search_field, "input[name='q']"
  element :search_button, "button[name='btnK']"
  elements :footer_links, "#footer a"
  section :menu, MenuSection, "#gbx3"
end

class SearchResults < SitePrism::Page
  set_url_matcher /google.com\/results\?.*/

  section :menu, MenuSection, "#gbx3"
  sections :search_results, SearchResultSection, "#results li"
end

# define sections used on multiple pages or multiple times on one page

class MenuSection < SitePrism::Section
  element :search, "a.search"
  element :images, "a.image-search"
  element :maps, "a.map-search"
end

class SearchResultSection < SitePrism::Section
  element :title, "a.title"
  element :blurb, "span.result-decription"
end

# now for some tests

When /^I navigate to the google home page$/ do
  @home = Home.new
  @home.load
end

Then /^the home page should contain the menu and the search form$/ do
  @home.wait_for_menu # menu loads after a second or 2, give it time to arrive
  @home.should have_menu
  @home.should have_search_field
  @home.should have_search_button
end

When /^I search for Sausages$/ do
  @home.search_field.set "Sausages"
  @home.search_button.click
end

Then /^the search results page is displayed$/ do
  @results_page = SearchResults.new
  @results_page.should be_displayed
end

Then /^the search results page contains 10 individual search results$/ do
  @results_page.wait_for_search_results
  @results_page.should have_search_results
  @results_page.search_results.size.should == 10
end

Then /^the search results contain a link to the wikipedia sausages page$/ do
  @results_page.search_results.map {|sr| sr.title['href']}.should include "http://en.wikipedia.org/wiki/Sausage"
end
```

Now for the details...

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

#### Waiting for an element to appear on a page

The final method added by calling `element` is the `wait_for_<element_name>` method.
Calling the method will cause the test to wait for the Capybara's
default wait time for the element to exist. It is also possible to use a
custom amount of time to wait. Using the same example as above:

```ruby
class Home < SitePrism::Page
  set_url "http://www.google.com"

  element :search_field, "input[name='q']"
end
```

... you can wait for the search field to exist like this:

```ruby
@home_page = Home.new
@home.load
@home.wait_for_search_field
# or...
@home.wait_for_search_field(10) #will wait for 10 seconds for the search field to appear
```

#### Summary of what the element method provides:

Given:

```ruby
class Home < SitePrism::Page
  element :search_field, "input[name='q']"
end
```

The following methods are available:

```ruby
@home.search_field
@home.has_search_field?
@home.wait_for_search_field
@home.wait_for_search_field(10)
```

### Element Collections

Sometimes you don't want to deal with an individual element but rather
with a collection of similar elements, for example, a list of names. To
enable this, SitePrism provides the `elements` method on the Page class.
Here's how it works:

```ruby
class Friends < SitePrism::Page
  elements :names, "ul#names li a"
end
```

Just like the `element` method, the `elements` method takes 2 arguments:
the first being the name of the elements as a symbol, the second is the
css locator that would return the array of capybara elements.

#### Accessing the elements

Just like the `element` method, the `elements` method adds a few methods
to the Page class. The first one is of the name of the element
collection which returns an array of capybara elements that match the
css locator. Using the example above:

```ruby
class Friends < SitePrism::Page
  elements :names, "ul#names li a"
end
```

You can access the element collection like this:

```ruby
@friends_page = Friends.new
# ...
@friends_page.names #=> [<Capybara::Element>, <Capybara::Element>, <Capybara::Element>]
```

With that you can do all the normal things that are possible with
arrays:


```ruby
@friends_page.names.each {|name| puts name.text}
@friends_page.names.map {|name| name.text}.should == ["Alice", "Bob", "Fred"]
@friends_page.names.size.should == 3
```

#### Testing for the existence of the element collection

Just like the `element` method, the `elements` method adds a method to
the page that will allow you to check for the existence of the
collection, called `has_<element collection name>?`. As long as there is
at least 1 element in the array, the method will return true, otherwise
false. For example, with the following page:

```ruby
class Friends < SitePrism::Page
  elements :names, "ul#names li a"
end
```

... the following method is available:

```ruby
@friends_page.has_names? #=> returns true if at least one element is found using the relevant locator
```

...which allows for pretty test code:

```ruby
Then /^there should be some names listed on the page$/ do
  @friends_page.should have_names
end
```

#### Waiting for the element collection

Just like for an individual element, the tests can be told to wait for
the existence of the element collection. The `elements` method adds a
`wait_for_<element collection name>` method that will wait for
Capybara's default wait time until at least 1 element is found that
matches the locator. For example, with the following page:

```ruby
class Friends < SitePrism::Page
  elements :names, "ul#names li a"
end

```

... you can wait for the existence of a list of names like this:

```ruby
@friends_page.wait_for_names
```

Again, you can customise the wait time by supplying a number of seconds
to wait for:

```ruby
@friends_page.wait_for_names(10)
```

### Checking that all mapped elements are present on the page

Throught my time in test automation I keep getting asked to provide the
ability to check that all elements that should be on the page are on the
page. Why people would want to test this, I don't know. But if that's
what you want to do, SitePrism provides the `#all_there?` method that
will return true if all mapped elements (and sections... see below) are
present in the browser, false if they're not all there.

```ruby
@friends_page.all_there? #=> true/false

# and...

Then /^the friends page contains all the expected elements$/ do
  @friends_page.should be_all_there
end

```

## Sections

SitePrism allows you to model sections of a page that appear on multiple
pages or that appear a number of times on a page seperatly from Pages.
SitePrism provides the Section class for this task.

A section that appears on multiple pages, though it has the same
structure, may appear at a different location in the DOM on different
pages. For this reason, each section has a concept of a root node; a
capybara element that becomes the reference point from which the
elements within sections can be found under.

The following example demonstrates the concept of a section using the
top level menu on the google home page:

```ruby
# define the section that appears on both pages

class MenuSection < SitePrism::Section
  element :search, "a.search"
  element :images, "a.image-search"
  element :maps, "a.map-search"
end

# define 2 pages, each containing the same section

class Home < SitePrism::Page
  section :menu, MenuSection, "#gbx3"
end

class SearchResults < SitePrism::Page
  section :menu, MenuSection, "#gbx48"
end
```

You can see that the `MenuSection` is used in both the `Home` and
`SearchResults` pages, but each has slightly different root node. The
capybara element that is found by the css locator becomes the root node
for the relevant page's instance of the `MenuSection` section.

# This README.md file is a work in progress. It should be finished soon...

