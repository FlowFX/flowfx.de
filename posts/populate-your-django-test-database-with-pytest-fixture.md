<!-- 
.. title: Populate your Django test database with pytest fixtures
.. slug: populate-your-django-test-database-with-pytest-fixtures
.. date: 2017-05-05 07:33:20 UTC-05:00
.. tags: python, pytest, django, fixture, database, testing
.. category: 
.. link: 
.. description: 
.. type: text
-->

I'm working on a side project that uses data from an external API. For performance reasons I store this data in a local database. But when running pytest, all my tests always start with a clean database. That's not good, as I need the data to run many of the tests, and adding it from the API is very time consuming.

Of course, Django has a solution for this, confusingly called `fixtures`, and pytest has a way to use Django fixtures in a custom pytest fixture to [populate the database with initial test data](https://pytest-django.readthedocs.io/en/latest/database.html#populate-the-database-with-initial-test-data).

Because it took me a while to find this, I document it here. It works like this:

## Dump the data
Using Django's own [`dumpdata`](https://docs.djangoproject.com/en/1.11/ref/django-admin/#dumpdata) management command, you dump all or selected tables from your local database into a JSON file in a subfolder of the app named `fixtures`. My Django app is called `potatoes`, and I want the data for my two models `Potato` and `SturdyPotato`.

``` bash
$ ./manage.py dumpdata potatoes.Potato potatoes.SturdyPotato -o potatoes/fixtures/potatoes_data.json
```

## Load the data
The corresponding [`loaddata`](https://docs.djangoproject.com/en/1.11/ref/django-admin/#loaddata) command can be used with pytest's `django_db_setup` fixture to load the data into the test database.

``` python
# tests/conftest.py

import pytest

from django.core.management import call_command

@pytest.fixture(scope='session')
def django_db_setup(django_db_setup, django_db_blocker):
    with django_db_blocker.unblock():
        call_command('loaddata', 'potatoes_data.json')
```

## Use pytest fixture
Now, in every test that needs it, I use this session-scoped fixture, and the test data is available.

``` python
# tests/test_models.py

def test_my_potatoes(db, django_db_setup):
    # GIVEN a full database of potatoes, as provided by the django_db_setup fixture
    all_my_potatoes = Potato.objects.all()
    …
```