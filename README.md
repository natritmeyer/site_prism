# SitePrism
_A Page Object Model DSL for Capybara_

SitePrism gives you a simple, clean and semantic DSL for describing your site using the Page Object Model pattern, for use with Capybara in automated acceptance testing. It encourages the "Page Object Model" pattern and makes it easy to do it well. One of its aims is to provide a pleasant syntax when using rspec/cucumber matchers and expectations.

## Setup

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
below.

### Pages


