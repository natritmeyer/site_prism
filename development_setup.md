# SitePrism dev setup

To successfully get SitePrism running locally, you will need ..

- To fork the repo
- To have geckodriver and/or chromedriver installed on your System PATH

```
$ git clone git@github.com:your_user_name/site_prism.git
$ cd site_prism
$ cp .env.example .env
$ bundle
```

_You can amend which browser you run integration tests on by editing the value in your `.env` file_

- Write your code adding unit / feature tests / documentation where appropriate
- Run `bundle exec rake` and ensure all 3 Raketasks pass **100%**
- Submit a pull request

Happy Testing / Developing!

Cheers,
The SitePrism Team

