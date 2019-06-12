# SitePrism dev setup

To successfully get SitePrism running locally, you need to fork the repo and have
`geckodriver` and/or `chromedriver` downloaded

```bash
$ git clone git@github.com:your_user_name/site_prism.git
$ cd site_prism
$ bundle
```

Hacking commands you may need are ...

```bash
$ bundle exec rake cukes # Run feature tests on firefox (Default browser)
$ bundle exec rake cukes browser=chrome # Run feature tests on chrome
$ bundle exec rake specs # Run all rspec tests
$ bundle exec rake # Runs feature tests on firefox, then specs, then runs rubocop
```

- Write your code. Make sure to add unit / feature tests AND documentation (If appropriate)
- Run `bundle exec rake` and ensure it passes
- Submit a pull request

Happy Testing / Developing!

Cheers,

The SitePrism Team
