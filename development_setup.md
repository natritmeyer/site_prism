# SitePrism dev setup

To successfully get SitePrism running locally, you will need ...

- To fork the repo
- To have geckodriver and/or chromedriver installed and available on your System PATH

```
$ git clone git@github.com:your_user_name/site_prism.git
$ cd site_prism
$ cp .env.example .env
$ bundle
```

_You can amend which browser you run integration tests on by editing the value in `.env`_

- Write your code (adding unit / feature tests / documentation), where appropriate
- Run `bundle exec rake` and ensure it passes
- Submit a pull request

Happy Testing / Developing!

Cheers,
The SitePrism Team
