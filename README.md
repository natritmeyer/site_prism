# SitePrism
_A Page Object Model DSL for Capybara_

SitePrism gives you a simple, clean and semantic DSL for describing your site using the Page Object Model pattern, for use with Capybara in automated acceptance testing.

Find the pretty documentation here: http://rdoc.info/gems/site_prism/frames

[![Build Status](https://travis-ci.org/natritmeyer/site_prism.png)](https://travis-ci.org/natritmeyer/site_prism)

Make sure to add your project/company to https://github.com/natritmeyer/site_prism/wiki/Who-is-using-SitePrism

## Synopsis

Here's an overview of how SitePrism is designed to be used:

```ruby
# define our site's pages

class Home < SitePrism::Page
  set_url "/index.htm"
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

  def search_result_links
    search_results.map {|sr| sr.title['href']}
  end
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
  expect(@home).to have_menu
  expect(@home).to have_search_field
  expect(@home).to have_search_button
end

When /^I search for Sausages$/ do
  @home.search_field.set "Sausages"
  @home.search_button.click
end

Then /^the search results page is displayed$/ do
  @results_page = SearchResults.new
  expect(@results_page).to be_displayed
end

Then /^the search results page contains 10 individual search results$/ do
  @results_page.wait_for_search_results
  expect(@results_page).to have_search_results count: 10
end

Then /^the search results contain a link to the wikipedia sausages page$/ do
  expect(@results_page.search_result_links).to include "http://en.wikipedia.org/wiki/Sausage"
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
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
```

### Using SitePrism with RSpec

If you're using rspec instead, here's what needs requiring:

```ruby
require 'capybara'
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
multiple pages, or many times on a page using the concept of sections.

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

If you've set Capybara's `app_host` then you can set the URL as follows:

```ruby
class Home < SitePrism::Page
  set_url "/home.htm"
end
```

Note that setting a URL is optional - you only need to set a url if you want to be able to navigate
directly to that page. It makes sense to set the URL for a page model of a home
page or a login page, but probably not a search results page.

#### Parameterized URLs

SitePrism uses the Addressable gem and therefore allows for parameterized URLs. Here is
a simple example:

```ruby
class UserProfile < SitePrism::Page
  set_url "/users{/username}"
end
```

...and a more complex example:

```ruby
class Search < SitePrism::Page
  set_url "/search{?query*}"
end
```

See https://github.com/sporkmonger/addressable for more details on parameterized URLs.

### Navigating to the Page

Once the URL has been set (using `set_url`), you can navigate directly
to the page using `#load`:

```ruby
@home_page = Home.new
@home_page.load
```

#### Navigating to a page with a parameterized URL

The `#load` method takes parameters and will apply them to the URL. Using the examples above:

```ruby
class UserProfile < SitePrism::Page
  set_url "/users{/username}"
end

@user_profile = UserProfile.new
@user_profile.load #=> /users
@user_profile.load(username: 'bob') #=> loads /users/bob
```

...and...

```ruby
class Search < SitePrism::Page
  set_url "/search{?query*}"
end

@search = Search.new
@search.load(query: 'simple') #=> loads /search?query=simple
@search.load(query: {'color'=> 'red', 'text'=> 'blue'}) #=> loads /search?color=red&text=blue
```

This will tell whichever capybara driver you have configured to
navigate to the URL set against that page's class.

See https://github.com/sporkmonger/addressable for more details on parameterized URLs.

### Verifying that a particular page is displayed

Automated tests often need to verify that a particular page is
displayed. SitePrism can automatically parse your URL template
and verify that whatever components your template specifies match the
currently viewed page.  For example, with the following URL template:

```ruby
class Account < SitePrism::Page
  set_url "/accounts/{id}{?query*}"
end
```

The following test code would pass:

```ruby
@account_page = Account.new
@account_page.load(id: 22, query: { token: "ca2786616a4285bc" })

expect(@account_page.current_url).to end_with "/accounts/22?token=ca2786616a4285bc"
expect(@account_page).to be_displayed
```

Calling `#displayed?` will return true if the browser's current URL
matches the page's template and false if it doesn't.

#### Specifying parameter values for templated URLs

Sometimes you want to verify not just that the current URL matches the
template, but that you're looking at a specific page matching that
template.

Given the previous example, if you wanted to ensure that the browser had loaded
account number 22, you could assert the following:

```ruby
expect(@account_page).to be_displayed(id: 22)
```

You can even use regular expressions.  If, as a contrived example, you wanted to
ensure that the browser was displaying an account with an id ending with 2, you could
say:

```ruby
expect(@account_page).to be_displayed(id: /2\z/)
```

#### Accessing specific matches from a templated URL in your tests

If passing options to `displayed?` isn't powerful enough to meet your
needs, you can directly access and assert on the `url_matches` found
when comparing your page's URL template to the current_url:

```ruby
@account_page = Account.new
@account_page.load(id: 22, query: { token: "ca2786616a4285bc", color: 'irrelevant' })

expect(@account_page).to be_displayed(id: 22)
expect(@account_page.url_matches['query']['token']).to eq "ca2786616a4285bc"
```

#### Falling back to basic regexp matchers

If SitePrism's built-in URL matching is not sufficient for your needs
 you can override and use SitePrism's previous support for regular expression-based
URL matchers by it by calling `set_url_matcher`:

```ruby
class Account < SitePrism::Page
  set_url_matcher %r{/accounts/\d+}
end
```

#### Testing for Page display

SitePrism's `#displayed?` predicate method allows for semantic code in
your test:

```ruby
Then /^the account page is displayed$/ do
  expect(@account_page).to be_displayed
  expect(@some_other_page).not_to be_displayed
end
```

### Getting the Current Page's URL

SitePrism allows you to get the current page's URL. Here's how it's
done:

```ruby
class Account < SitePrism::Page
end

@account = Account.new
#...
@account.current_url #=> "http://www.example.com/account/123"
expect(@account.current_url).to include "example.com/account/"
```

### Page Title

Getting a page's title isn't hard:

```ruby
class Account < SitePrism::Page
end

@account = Account.new
#...
@account.title #=> "Welcome to Your Account"
```

### HTTP vs. HTTPS

You can easily tell if the page is secure or not by checking to see if
the current URL begins with 'https' or not. SitePrism provides the
`secure?` method that will return true if the current url begins with
'https' and false if it doesn't. For example:

```ruby
class Account < SitePrism::Page
end

@account = Account.new
#...
@account.secure? #=> true/false
expect(@account).to be_secure
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
takes 2 arguments: the name of the element as a symbol, and a css selector
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
@home = Home.new
@home.load

@home.search_field #=> will return the capybara element found using the selector
@home.search_field.set "the search string" #=> since search_field returns a capybara element, you can use the capybara API to deal with it
@home.search_field.text #=> standard method on a capybara element; returns a string
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
@home = Home.new
@home.load
@home.has_search_field? #=> returns true if it exists, false if it doesn't
```

...which makes for nice test code:

```ruby
Then /^the search field exists$/ do
  expect(@home).to have_search_field
end
```

#### Testing that an element does not exist

To test that an element does not exist on the page, it is not possible to just call
`#not_to have_search_field`. SitePrism supplies the `#has_no_<element>?` method
that should be used to test for non-existence. Using the above example:

```ruby
@home = Home.new
@home.load
@home.has_no_search_field? #=> returns true if it doesn't exist, false if it does
```

...which makes for nice test code:

```ruby
Then /^the search field exists$/ do
  expect(@home).to have_no_search_field #NB: NOT => expect(@home).not_to have_search_field
end
```

#### Waiting for an element to exist on a page

Another method added by calling `element` is the `wait_for_<element_name>` method.
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
@home = Home.new
@home.load
@home.wait_for_search_field
# or...
@home.wait_for_search_field(10) #will wait for 10 seconds for the search field to appear
```

#### Waiting for an element to become visible

Another method added by calling `element` is the
`wait_until_<element_name>_visible` method. Calling this method will
cause the test to wait for Capybara's default wait time for the element
to become visible (*not* the same as existence!). You can customise the
wait time be supplying a number of seconds to wait. Using the above
example:

```ruby
@home.wait_until_search_field_visible
# or...
@home.wait_until_search_field_visible(10)
```

#### Waiting for an element to become invisible

Another method added by calling `element` is the
`wait_until_<element_name>_invisible` method. Calling this method will
cause the test to wait for Capybara's default wait time for the element
to become invisible. You can customise the wait time be supplying a number
of seconds to wait. Using the above example:

```ruby
@home.wait_until_search_field_invisible
# or...
@home.wait_until_search_field_invisible(10)
```

#### CSS Selectors vs. XPath Expressions

While the above examples all use CSS selectors to find elements, it is
possible to use XPath expressions too. In SitePrism, everywhere that you
can use a CSS selector, you can use an XPath expression. An example:

```ruby
class Home < SitePrism::Page
  # CSS Selector:
  element :first_name, "div#signup input[name='first-name']"

  #same thing as an XPath expression:
  element :first_name, :xpath, "//div[@id='signup']//input[@name='first-name']"
end
```

#### Summary of what the element method provides:

Given:

```ruby
class Home < SitePrism::Page
  element :search_field, "input[name='q']"
end
```

...then the following methods are available:

```ruby
@home.search_field
@home.has_search_field?
@home.has_no_search_field?
@home.wait_for_search_field
@home.wait_for_search_field(10)
@home.wait_until_search_field_visible
@home.wait_until_search_field_visible(10)
@home.wait_until_search_field_invisible
@home.wait_until_search_field_invisible(10)

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
css selector that would return the array of capybara elements.

#### Accessing the elements

Just like the `element` method, the `elements` method adds a few methods
to the Page class. The first one is of the name of the element
collection which returns an array of capybara elements that match the
css selector. Using the example above:

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
expect(@friends_page.names.map {|name| name.text}.to eq ["Alice", "Bob", "Fred"]
expect(@friends_page.names.size).to eq 3
expect(@friends_page).to have(3).names
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
@friends_page.has_names? #=> returns true if at least one element is found using the relevant selector
```

...which allows for pretty test code:

```ruby
Then /^there should be some names listed on the page$/ do
  expect(@friends_page).to have_names
end
```

#### Waiting for the element collection

Just like for an individual element, the tests can be told to wait for
the existence of the element collection. The `elements` method adds a
`wait_for_<element collection name>` method that will wait for
Capybara's default wait time until at least 1 element is found that
matches the selector. For example, with the following page:

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

#### Waiting for the elements to be visible or invisible

Like the individual elements, calling the `elements` method will create
two methods: `wait_until_<elements_name>_visible` and
`wait_until_<elements_name>_invisible`. Calling these methods will cause
your test to wait for the elements to become visible or invisible. Using
the above example:

```ruby
@friends_page.wait_until_names_visible
# and...
@friends_page.wait_until_names_invisible
```

It is possible to wait for a specific amount of time instead of using
the default Capybara wait time:

```ruby
@friends_page.wait_until_names_visible(5)
# and...
@friends_page.wait_until_names_invisible(7)
```

### Checking that all mapped elements are present on the page

Throughout my time in test automation I keep getting asked to provide the
ability to check that all elements that should be on the page are on the
page. Why people would want to test this, I don't know. But if that's
what you want to do, SitePrism provides the `#all_there?` method that
will return true if all mapped elements (and sections... see below) are
present in the browser, false if they're not all there.

```ruby
@friends_page.all_there? #=> true/false

# and...

Then /^the friends page contains all the expected elements$/ do
  expect(@friends_page).to be_all_there
end

```

## Sections

SitePrism allows you to model sections of a page that appear on multiple
pages or that appear a number of times on a page separately from Pages.
SitePrism provides the Section class for this task.

### Individual Sections

In the same way that SitePrism provides `element` and `elements`, it
provides `section` and `sections`. The first returns an instance of a
page section, the second returns an array of section instances, one for
each capybara element found by the supplied css selector. What follows
is an explanation of `section`.


#### Defining a Section

A section is similar to a page in that it inherits from a SitePrism
class:

```ruby
class MenuSection < SitePrism::Section
end
```

At the moment, this section does nothing.

#### Adding a section to a page

Pages include sections that's how SitePrism works. Here's a page that
includes the above `MenuSection` section:

```ruby
class Home < SitePrism::Page
  section :menu, MenuSection, "#gbx3"
end
```

The way to add a section to a page (or another section -
SitePrism allows adding sections to sections) is to call the `section`
method. It takes 3 arguments: the first is the name of the section as
referred to on the page (sections that appear on multiple pages can be
named differently). The second argument is the class of which an
instance will be created to represent the page section, and the third
argument is a css selector that identifies the root node of the section
on this page (note that the css selector can be different for different
pages as the whole point of sections is that they can appear in
different places on different pages).

#### Accessing a page's section

The `section` method (like the `element` method) adds a few methods to
the page or section class it was called against. The first method that
is added is one that returns an instance of the section, the method name
being the first argument to the `section` method. Here's an example:

```ruby
# the section:

class MenuSection < SitePrism::Section
end

# the page that includes the section:

class Home < SitePrism::Page
  section :menu, MenuSection, "#gbx3"
end

# the page and section in action:

@home = Home.new
@home.menu #=> <MenuSection...>
```

When the `menu` method is called against `@home`, an instance of
`MenuSection` (the second argument to the `section` method) is returned.
The third argument that is passed to the `section` method is the css
selector that will be used to find the root element of the section; this
root node becomes the 'scope' of the section.

The following shows that though the same section can appear on multiple
pages, it can take a different root node:

```ruby
# define the section that appears on both pages

class MenuSection < SitePrism::Section
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
capybara element that is found by the css selector becomes the root node
for the relevant page's instance of the `MenuSection` section.

#### Adding elements to a section

This works just the same as adding elements to a page:

```ruby
class MenuSection < SitePrism::Section
  element :search, "a.search"
  element :images, "a.image-search"
  element :maps, "a.map-search"
end
```

Note that the css selectors used to find elements are searched for
within the scope of the root element of that section. The search for the
element won't be page-wide but it will only look in the section.

When the section is added to a page...

```ruby
class Home < SitePrism::Page
  section :menu, MenuSection, "#gbx3"
end
```

...then the section's elements can be accessed like this:

```ruby
@home = Home.new
@home.load

@home.menu.search #=> returns a capybara element representing the link to the search page
@home.menu.search.click #=> clicks the search link in the home page menu
@home.menu.search['href'] #=> returns the value for the href attribute of the capybara element representing the search link
@home.menu.has_images? #=> returns true or false based on whether the link is present in the section on the page
@home.menu.wait_for_images #=> waits for capybara's default wait time until the element appears in the page section

```

...which leads to some pretty test code:

```ruby
Then /^the home page menu contains a link to the various search functions$/ do
  expect(@home.menu).to have_search
  expect(@home.menu.search['href']).to include "google.com"
  expect(@home.menu).to have_images
  expect(@home.menu).to have_maps
end
```

##### Accessing section elements using a block

Sections have a `within` method that allows scoped access to the section's elements inside a block.  This is similar to Capybara's `within` method and allows for shorter test code particularly with nested sections.
Some of this test code can be made a little prettier by simply passing a block in.

```ruby
Then /^the home page menu contains a link to the various search functions$/ do
  @home.menu do |menu|
    expect(menu).to have_search
    expect(menu.search['href']).to include "google.com"
    expect(menu).to have_images
    expect(menu).to have_maps
  end
end
```

#### Getting a section's parent

It is possible to ask a section for its parent (page, or section if this
section is a subsection). For example, given the following setup:

```ruby
class MySubSection < SitePrism::Section
  element :some_element, "abc"
end

class MySection < SitePrism::Section
  section :my_subsection, MySubSection, "def"
end

class MyPage < SitePrism::Page
  section :my_section, MySection, "ghi"
end
```

...then calling `#parent` will return the following:

```ruby
@my_page = MyPage.new
@my_page.load

@my_page.my_section.parent #=> returns @my_page
@my_page.my_section.my_subsection.parent #=> returns @my_section
```

#### Getting a section's parent page

It is possible to ask a section for the page that it belongs to. For example,
given the following setup:

```ruby
class MenuSection < SitePrism::Section
  element :search, "a.search"
  element :images, "a.image-search"
  element :maps, "a.map-search"
end

class Home < SitePrism::Page
  section :menu, MenuSection, "#gbx3"
end
```

...you can get the section's parent page:

```ruby
@home = Home.new
@home.load
@home.menu.parent_page #=> returns @home
```

#### Testing for the existence of a section

Just like elements, it is possible to test for the existence of a
section. The `section` method adds a method called `has_<section name>?`
to the page or section it's been added to - same idea as what the
`has_<element name>?` method. Given the following setup:

```ruby
class MenuSection < SitePrism::Section
  element :search, "a.search"
  element :images, "a.image-search"
  element :maps, "a.map-search"
end

class Home < SitePrism::Page
  section :menu, MenuSection, "#gbx3"
end
```

... you can check whether the section is present on the page or not:

```ruby
@home = Home.new
#...
@home.has_menu? #=> returns true or false
```

Again, this allows pretty test code:

```ruby
expect(@home).to have_menu
expect(@home).not_to have_menu
```

#### Waiting for a section to exist

Another method added to the page or section by the `section` method is
`wait_for_<section name>`. Similar to what `element` does, this method
waits for the section to appear - the test will wait up to capybara's
default wait time until the root node of the element exists on the
page/section that our section was added to. Given the following setup:

```ruby
class MenuSection < SitePrism::Section
  element :search, "a.search"
  element :images, "a.image-search"
  element :maps, "a.map-search"
end

class Home < SitePrism::Page
  section :menu, MenuSection, "#gbx3"
end
```

... we can wait for the menu section to appear on the page like this:

```ruby
@home.wait_for_menu
@home.wait_for_menu(10) # waits for 10 seconds instead of capybara's default timeout
```

#### Waiting for a section to become visible or invisible

Like an element, it is possible to wait for a section to become visible
or invisible. Calling the `section` method creates two methods on the
relevant page or section:
`wait_until_<section_name>_visible` and
`wait_until_<section_name>_invisible`. Using the above example, here's
how they're used:

```ruby
@home = Home.new
@home.wait_until_menu_visible
# and...
@home.wait_until_menu_invisible
```

Again, as for an element, it is possible to give a specific amount of
time to wait for visibility/invisibility of a section. Here's how:

```ruby
@home = Home.new
@home.wait_until_menu_visible(5)
# and...
@home.wait_until_menu_invisible(3)
```

#### Sections within sections

You are not limited to adding sections only to pages; you can nest
sections within sections within sections within sections!

```ruby

# define a page that contains an area that contains a section for both logging in and registration, then modelling each of the sub sections separately

class Login < SitePrism::Section
  element :username, "#username"
  element :password, "#password"
  element :sign_in, "button"
end

class Registration < SitePrism::Section
  element :first_name, "#first_name"
  element :last_name, "#last_name"
  element :next_step, "button.next-reg-step"
end

class LoginRegistrationForm < SitePrism::Section
  section :login, Login, "div.login-area"
  section :registration, Registration, "div.reg-area"
end

class Home < SitePrism::Page
  section :login_and_registration, LoginRegistrationForm, "div.login-registration"
end

# how to login (fatuous, but demonstrates the point):

Then /^I sign in$/ do
  @home = Home.new
  @home.load
  @home.wait_for_login_and_registration
  expect(@home).to have_login_and_registration
  expect(@home.login_and_registration).to have_username
  @home.login_and_registration.login.username.set "bob"
  @home.login_and_registration.login.password.set "p4ssw0rd"
  @home.login_and_registration.login.sign_in.click
end

# how to sign up:

When /^I enter my name into the home page's registration form$/ do
  @home = Home.new
  @home.load
  expect(@home.login_and_registration).to have_first_name
  expect(@home.login_and_registration).to have_last_name
  @home.login_and_registration.first_name.set "Bob"
  # ...
end
```

#### Anonymous Sections

If you want to use a section more as a namespace for elements and are not
planning on re-using it, you may find it more convenient to define
an anonymous section using a block:

```ruby
class Home < SitePrism::Page
  section :menu, '.menu' do
    element :title, '.title'
    elements :items, 'a'
  end
end
```

This code will create an anonymous section that you can use in the same way
as an ordinary section:

```ruby
@home = Home.new
expect(@home.menu).to have_title
```

### Section Collections

An individual section represents a discrete section of a page, but often
sections are repeated on a page, an example is a search result listing -
each listing contains a title, a url and a description of the content.
It makes sense to model this only once and then to be able to access
each instance of a search result on a page as an array of SitePrism
sections. To achieve this, SitePrism provides the `sections` method that
can be called in a page or a section.

The only difference between `section` and `sections` is that whereas the
first returns an instance of the supplied section class, the second
returns an array containing as many instances of the section class as
there are capybara elements found by the supplied css selector. This is
better explained in code :)

#### Adding a Section collection to a page (or other section)

Given the following setup:

```ruby
class SearchResultSection < SitePrism::Section
  element :title, "a.title"
  element :blurb, "span.result-decription"
end

class SearchResults < SitePrism::Page
  sections :search_results, SearchResultSection, "#results li"
end
```

... it is possible to access each of the search results:

```ruby
@results_page = SearchResults.new
# ...
@results_page.search_results.each do |search_result|
  puts search_result.title.text
end
```

... which allows for pretty tests:

```ruby
Then /^there are lots of search_results$/ do
  expect(@results_page.search_results.size).to eq 10
  @results_page.search_results.each do |search_result|
    expect(search_result).to have_title
    expect(search_result.blurb.text).not_to be_nil
  end
end
```

The css selector that is passed as the 3rd argument to the
`sections` method ("#results li") is used to find a number of capybara
elements. Each capybara element found using the css selector is used to
create a new instance of the `SearchResultSection` and becomes its root
element. So if the css selector finds 3 `li` elements, calling
`search_results` will return an array containing 3 instances of
`SearchResultSection`, each with one of the `li` elements as it's root
element.

#### Anonymous Section Collections

You can define collections of anonymous sections the same way you would
define a single anonymous section:

```ruby
class SearchResults < SitePrism::Page
  sections :search_results, "#results li" do
    element :title, "a.title"
    element :blurb, "span.result-decription"
  end
end
```

#### Testing for existence of Sections

Using the example above, it is possible to test for the existence of the
sections. As long as there is at least one section in the array, the
sections exist. The `sections` method adds a `has_<sections name>?`
method to the page/section that our section has been added to. Given the
following example:

```ruby
class SearchResultSection < SitePrism::Section
  element :title, "a.title"
  element :blurb, "span.result-decription"
end

class SearchResults < SitePrism::Page
  sections :search_results, SearchResultSection, "#results li"
end
```

... here's how to test for the existence of the section:

```ruby
@results_page = SearchResults.new
# ...
@results_page.has_search_results?
```

...which allows pretty tests:

```ruby
Then /^there are search results on the page$/ do
  expect(@results.page).to have_search_results
end
```

#### Waiting for sections to appear

The final method added by `sections` to the page/section we're adding
our sections to is `wait_for_<sections name>`. It will wait for
capybara's default wait time for there to be at least one instance of
the section in the array of sections. For example:

```ruby
class SearchResultSection < SitePrism::Section
  element :title, "a.title"
  element :blurb, "span.result-decription"
end

class SearchResults < SitePrism::Page
  sections :search_results, SearchResultSection, "#results li"
end
```

... here's how to wait for the section:

```ruby
@results_page = SearchResults.new
# ...
@results_page.wait_for_search_results
@results_page.wait_for_search_results(10) #=> waits for 10 seconds instead of the default capybara timeout
```

## Load Validations

Load validations enable common validations to be abstracted and performed on a Page or Section to determine
when it has finished loading and is ready for interaction in your tests.

For example, suppose you have a page which displays a 'Loading...' message while the body of
the page is loaded in the background.  Load validations can be used to ensure tests wait for the correct url
to be displayed and the loading message removed before trying to interact with with the page.

Other use cases include Sections which are displayed conditionally and may take time to become ready to
interact with, such as animated lightboxes.

### Using Load Validations

Load validations can be used in three constructs:

* Passing a block to `Page#load`
* Passing a block to `Loadable#when_loaded`
* Calling `Loadable#loaded?`

#### Page#load

When a block is passed to the `Page#load` method, the url will be loaded normally and then the block will be
executed within the context of `when_loaded`.  See `when_loaded` documentation below for further details.

Example:

```ruby
# Load the page and then execute a block after all load validations pass:
my_page_instance.load do |page|
  page.do_something
end
```

#### Loadable#when_loaded

The `Loadable#when_loaded` method on a Loadable class instance will yield the instance of the class into a
block after all load validations have passed.

If any load validation fails, an error will be raised with the reason, if given, for the failure.

Example:

```ruby
# Execute a block after all load validations pass:
a_loadable_page_or_section.when_loaded do |loadable|
  loadable.do_something
end
```

#### Loadable#loaded?

You can explicitly run load validations on a Loadable via the `loaded?` method.
This method will execute all load validations on the object and return a boolean value.
In the event of a validation failure, a validation error can be accessed via the `load_error`
method on the object, if any error message was emitted by the failing validation.

Example:

```ruby
it 'loads the page' do
  some_page.load
  some_page.loaded?    #=> true if/when all load validations pass
  another_page.loaded? #=> false if any load validations fail
  another_page.load_error #=> A string error message if one was supplied by the failing load validation, or nil
end
```

### Defining Load Validations

A load validation is a block which returns a boolean value when evaluated against an instance of the Loadable.

```ruby
class SomePage < SitePrism::Page
  element :foo_element, '.foo'
  load_validation { has_foo_element? }
end
```

The block may instead return a two-element array which includes the boolean result as the first element and an
error message as the second element. It is highly recommended to supply an error message, as they are
extremely useful in debugging validation errors.

The error message will be ignored unless the boolean value is falsey.

```ruby
class SomePage < SitePrism::Page
  element :foo_element, '.foo'
  load_validation { [has_foo_element?, 'did not have foo element!'] }
end
```

Load validations may be defined on `SitePrism::Page` and `SitePrism::Section` classes (herein referred
to as `Loadables`) and are evaluated against an instance of the class when executed.

### Load Validation Inheritance and Execution Order

Any number of load validations may be defined on a Loadable class and will be inherited by its subclasses.

Load validations are executed in the order that they are defined.  Inherited load validations are executed
from the top of the inheritance chain (e.g. `SitePrism::Page` or `SitePrism::Section`) to the bottom.

For example:

```ruby
class BasePage < SitePrism::Page
  element :loading_message, '.loader'

  load_validation do
    wait_for_loading_message(1)
    [ has_no_loading_message?(wait: 10), 'loading message was still displayed' ]
  end
end

class FooPage < BasePage
  set_url '/foo'

  section :form, '#form'
  element :some_other_element, '.myelement'

  load_validation { [has_form?, 'form did not appear'] }
  load_validation { [has_some_other_element?, 'some other element did not appear'] }
end
```

In the above example, when `loaded?` is called on an instance of `FooPage`, the validations will be performed in the
following order:

1. The `SitePrism::Page` default load validation will check `displayed?`
2. The `BasePage` load validation will wait for the loading message to disappear.
3. The `FooPage` load validation will wait for the `form` element to be present.
4. The `FooPage` load validation will wait for the `some_other_element` element to be present.

NOTE: `SitePrism::Page` includes a default load validation on `page.displayed?` which is applied
to all pages.  It is therefore not necessary to define a load validation for this condition on
inheriting page objects.

## Using Capybara Query Options

When querying an element, section or a collection of elements or sections, you may
supply Capybara query options as arguments to the element and section methods in order
to refine the results of the query and enable Capybara to wait for all of the conditions
necessary to properly fulfill your request.

Given the following sample page and elements:

```ruby
class SearchResultSection < SitePrism::Section
  element :title, "a.title"
  element :blurb, "span.result-decription"
end

class SearchResults < SitePrism::Page
  element :footer, ".footer"
  sections :search_results, SearchResultSection, "#results li"
end
```

Asserting the attributes of an element or section returned by any method may fail if
the page has not finished loading the element(s):

```ruby
@results_page = SearchResults.new
# ...
expect(@results_page.search_results.size).to == 25 # This may fail!
```

The above query can be rewritten to utilize the Capybara :count option when querying for
the collection, which in turn causes Capybara to expect some number of results to be returned.
The method calls below will succeed, provided the elements appear on the page within the timeout:

```ruby
@results_page = SearchResults.new
# ...
@results_page.has_search_results? :count => 25
# OR
@results_page.search_results :count => 25
# OR
@results_page.wait_for_search_results nil, :count => 25 # wait_for_<element_name> expects a timeout value to be passed as the first parameter or nil to use the default timeout value.
```

Now we can write pretty, non-failing tests without hard coding these options
into our page and section classes:

```ruby
Then /^there are search results on the page$/ do
  expect(@results.page).to have_search_results :count => 25
end
```

This is supported for all of the Capybara options including, but not limited to :count, :text,
:wait, etc. This can also be used when defining page objects. Eg:

```ruby
class SearchResults < SitePrism::Page
    element :footer, ".footer"
    element :view_more, "li", text: "View More"
    sections :search_results, SearchResultSection, "#results li"
end
```

### Methods Supporting Capybara Options

The following element methods allow Capybara options to be passed as arguments to the method:

```ruby
@results_page.<element_or_section_name> :text => "Welcome!"
@results_page.has_<element_or_section_name>? :count => 25
@results_page.has_no_<element_or_section_name>? :text => "Logout"
@results_page.wait_for_<element_or_section_name> :count => 25
@results_page.wait_until_<element_or_section_name>_visible :text => "Some ajaxy text appears!"
@results_page.wait_until_<element_or_section_name>_invisible :text => "Some ajaxy text disappears!"
```

## Test views with Page objects

It's possible to use the same page objects of integration tests for view tests, too,
just pass the rendered HTML to the ```load``` method:

```ruby
require 'spec_helper'

describe 'admin/things/index' do
  let(:list_page) { AdminThingsListPage.new }
  let(:thing) { build(:thing, some_attribute: 'some attribute') }

  it 'contains the things we expect' do
    assign(:things, [thing])

    render template: 'admin/things/index'

    list_page.load(rendered)

    expect(list_page.rows.first.some_attribute).to have_text('some attribute')
  end
end
```

## IFrames

SitePrism allows you to interact with iframes. An iframe is declared as
a `SitePrism::Page` class, and then referenced by the page or section it
is embedded into. Like a section, it is possible to test for the
existence of the iframe, wait for it to exist as well as interact with
the page it contains.

### Creating an iframe

An iframe is declared in the same way as a Page:

```ruby
class MyIframe < SitePrism::Page
  element :some_text_field, "input.username"
end
```

To expose the iframe, reference it from another page or class using the `iframe`
method. The `iframe` method takes 3 arguments; the name by which you
would like to reference the iframe, the page class that represents the
iframe, and an ID or class by which you can locate the iframe. For example:

```ruby
class PageContainingIframe < SitePrism::Page
  iframe :my_iframe, MyIframe, "#my_iframe_id"
end
```

The third argument to the `iframe` method must
contain a selector that will locate the iframe node.

### Testing for an iframe's existence

Like an element or section, it is possible to test for an iframe's
existence using the auto-generated `has_<iframe_name>?` method. Using
the above example, here's how it's done:

```ruby
@page = PageContainingIframe.new
# ...
@page.has_my_iframe? #=> true
expect(@page).to have_my_iframe
```

### Waiting for an iframe

Like an element or section, it is possible to wait for an iframe to
exist by using the `wait_for_<iframe_name>` method. For example:

```ruby
@page = PageContainingIframe.new
# ...
@page.wait_for_my_iframe
```

### Interacting with an iframe's contents:

Since an iframe contains a fully fledged SitePrism::Page, you are able
to interact with the elements and sections defined within it. Due to
capybara internals it is necessary to pass a block to the iframe instead
of simply calling methods on it; the block argument is the
SitePrism::Page that represents the iframe's contents. For example:

```ruby
# SitePrism::Page representing the iframe
class Login < SitePrism::Page
  element :username, "input.username"
  element :password, "input.password"
end

# SitePrism::Page representing the page that contains the iframe
class Home < SitePrism::Page
  set_url "http://www.example.com"

  iframe :login_area, Login, "#login_and_registration"
end

# cucumber step that performs login
When /^I log in$/ do
  @home = Home.new
  @home.load

  @home.login_area do |frame|
    #`frame` is an instance of the `Login` class
    frame.username.set "admin"
    frame.password.set "p4ssword"
  end
end
```

## SitePrism Configuration

SitePrism can be configured to change its behaviour.

### Using Capybara Implicit Waits

By default, SitePrism element and section methods do not utilize
Capybara's implicit wait methodology and will return immediately if
the element or section requested is not found on the page.  Add the
following code to your spec_helper file to enable Capybara's implicit
wait methodology to pass through:

```ruby
SitePrism.configure do |config|
  config.use_implicit_waits = true
end
```

This enables you to replace this:

```ruby
# wait_until methods always wait for the element to be present on the page:
@search_page.wait_for_search_results

# Element and section methods do not:
@search_page.search_results
```

with this:

```ruby
# With implicit waits enabled, use of wait_until methods is no longer required. This method will
# wait for the element to be found on the page until the Capybara default timeout is reached.
@search_page.search_results
```

## Using SitePrism with VCR

There's a SitePrism plugin called `site_prism.vcr` that lets you use
SitePrism with the VCR gem. Check it out here:

* https://github.com/dnesteryuk/site_prism.vcr

# Epilogue

So, we've seen how to use SitePrism to put together page objects made up
of pages, elements, sections and iframes. But how to organise this stuff? There
are a few ways of saving yourself having to create instances of pages
all over the place. Here's an example of this common problem:

```ruby
@home = Home.new # <-- noise
@home.load
@home.search_field.set "Sausages"
@home.search_field.search_button.click
@results_page = SearchResults.new # <-- noise
expect(@results_page).to have_search_result_items
```

The annoyance (and, later, maintenance nightmare) is having to create
`@home` and `@results_page`. It would be better to not have to create
instances of pages all over your tests.

The way I've dealt with this problem is to create a class containing
methods that return instances of the pages. Eg:

```ruby
# our pages

class Home < SitePrism::Page
  #...
end

class SearchResults < SitePrism::Page
  #...
end

class Maps < SitePrism::Page
  #...
end

# here's the app class that represents our entire site:

class App
  def home
    Home.new
  end

  def results_page
    SearchResults.new
  end

  def maps
    Maps.new
  end
end

# and here's how to use it:

#first line of the test...
Given /^I start on the home page$/ do
  @app = App.new
  @app.home.load
end

When /^I search for Sausages$/ do
  @app.home.search_field.set "sausages"
  @app.home.search_button.click
end

Then /^I am on the results page$/ do
  expect(@app.results_page).to be_displayed
end

# etc...
```

The only thing that needs instantiating is the App class - from then on
pages don't need to be initialized, they are now returned by methods on
@app. Maintenance win!
