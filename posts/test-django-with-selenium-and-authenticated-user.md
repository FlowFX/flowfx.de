<!--
.. title: Test Django with Selenium, pytest and user authentication
.. slug: test-django-with-selenium-pytest-and-user-authentication
.. date: 2017-10-17 10:13:16 UTC-05:00
.. tags: django, pytest, selenium, testing
.. category: 
.. link: 
.. description: 
.. type: text
-->

When testing a Django app with [Selenium](http://selenium-python.readthedocs.io/), how do you authenticate the user and test pages that require to be logged in?

Of course: **[StackOverflow has the answer](https://stackoverflow.com/a/22497239).**

The following is the actual code that I use to make this work with [pytest](https://docs.pytest.org/en/latest/). It requires [pytest-django](https://pytest-django.readthedocs.io/).

## pytest fixtures
In pytest everything is contained in neat test fixtures.

### Browser
The first fixture provides a broser/webdriver instance with an anonymous user. The default way of using Selenium. 

```python
# system_tests/conftest.py

from selenium import webdriver

@pytest.fixture(scope='module')
def browser(request):
    """Provide a selenium webdriver instance."""
    # SetUp
    options = webdriver.ChromeOptions()
    options.add_argument('headless')

    browser_ = webdriver.Chrome(chrome_options=options)

    yield browser_

    # TearDown
    browser_.quit()
```

### User
To be able to authenticate, I need a user in the database. Using [Factory Boy](https://factoryboy.readthedocs.io/en/latest/orms.html#django):

```python
# system_tests/conftest.py

from django.contrib.auth.hashers import make_password
from accounts.factories import UserFactory

TESTEMAIL = 'test-user@example.com'
TESTPASSWORD = 'a-super-secret-password'

@pytest.fixture()
def user(db):
    """Add a test user to the database."""
    user_ = UserFactory.create(
        name='I am a test user',
        email=TESTEMAIL,
        password=make_password(TESTPASSWORD),
    )

    return user_
```

### Authenticated browser
To get the authenticated browser, the first two fixtures are required, plus the Django `TestClient` and `LiveServer` fixtures which, for pytest, are provided by `pytest-django`. Using the code from SO:

```python
# system_tests/conftest.py

@pytest.fixture()
def authenticated_browser(browser, client, live_server, user):
    """Return a browser instance with logged-in user session."""
    client.login(email=TESTEMAIL, password=TESTPASSWORD)
    cookie = client.cookies['sessionid']

    browser.get(live_server.url)
    browser.add_cookie({'name': 'sessionid', 'value': cookie.value, 'secure': False, 'path': '/'})
    browser.refresh()

    return browser
```


## The tests
Now the Selenium test can use the `authenticated_browser` fixture. 

```python
# system_tests/test_django.py

def test_django_with_authenticated_user(live_server, authenticated_browser):
    """A Selenium test."""
    browser = authenticated_browser

    # Open the home page
    browser.get(live_server.url)
    …
```

To test logging in and out of the app, I use the unauthenticated browser instance plus the `user` fixture.

```python
# system_tests/test_django.py

def test_login_of_anonymous_user(live_server, browser, user):
    # Open the home page
    browser.get(live_server.url)
    
    # Click the 'login' button
    browser.find_element_by_id('id_link_to_login')).click()
    …
```

## Summary
These are the pytest fixtures that I use to test a Django app with an authenticated user.

If there is a better way to do this, [please tell me!](link://slug/contact) I want to know.