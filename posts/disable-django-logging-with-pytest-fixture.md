<!-- 
.. title: Disable Django/Python logging with pytest fixture
.. slug: disable-django-logging-with-pytest-fixture
.. date: 2017-04-10 12:11:39 UTC-05:00
.. tags: python, django, logging, pytest, fixture
.. category: 
.. link: 
.. description: 
.. type: text
-->

Yesterday, I added [Sentry error tracking](https://sentry.io/) to my Django app, and configured it to register every log entry with level INFO and above. Now, everytime I ran my test suite, there were events logged with Sentry that I didn't really care about. Naturally, I wanted to disable the default logging behavior for tests.

StackOverflow, naturally, provides part of the answer:

> ```logging.disable(logging.CRITICAL)```
> 
> will disable all logging calls with levels less severe than or equal to CRITICAL.
>
> ([http://stackoverflow.com/a/5255760](http://stackoverflow.com/a/5255760))

But how to run this on every test? Pytest to the rescue! I use an [autouse fixture](https://docs.pytest.org/en/latest/fixture.html#autouse-fixtures-xunit-setup-on-steroids):

> - if an autouse fixture is defined in a **conftest.py** file then all tests in all test modules below its directory will invoke the fixture.

And this is what I put into my `conftest.py` files:

``` python
@pytest.fixture(autouse=True)
def disable_logging():
    """Disable logging in all tests."""
    logging.disable(logging.INFO)
```

That's it. Love it!
