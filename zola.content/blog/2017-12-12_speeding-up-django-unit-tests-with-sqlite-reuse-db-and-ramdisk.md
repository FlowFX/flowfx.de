---
title: "Speeding up Django unit tests with SQLite, reuse-db and RAMDisk"
slug: speeding-up-django-unit-tests-with-sqlite-reuse-db-and-ramdisk
date: 2017-12-12
taxonomies:
  tags: ["django", " testing", " pytest", " in-memory", " sqlite"]
  categories: 
---


Recently, [Harry](https://twitter.com/hjwp/) wrote a post about [how to speed up Django unit-testing](http://www.obeythetestinggoat.com/speeding-up-django-unit-tests-with-sqlite-keepdb-and-devshm.html) by using a persistent in-memory SQLite database.

While Harry uses the default Django testrunner and a Linux machine, I use `pytest` with `pytest-django` on a Mac. This changes a few things, and this post will show the differences. So it's very specific to:

- Django
- pytest
- macOS

## Create and mount the RAMDisk

`/dev/shm` is a Linux thing. But Harry already provided the link to [a working solution on Stack Overflow](https://stackoverflow.com/questions/2033362/does-os-x-have-an-equivalent-to-dev-shm#2033417) to how to do this on macOS.

```bash
$ hdiutil attach -nomount ram://$((2 * 1024 * SIZE_IN_MB))
/dev/disk2

$ diskutil eraseVolume HFS+ RAMDisk /dev/disk2
```

This creates an in-memory Volume that can store the persistent SQLite database.

## Use SQLite

Maybe I'm doing this all wrong, but because I use pytest, I configure the test database in a separate configuration file like this.

```python
# config/settings/testing.py
from .common import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
        'TEST': {}
    }
}
```

## Use it in-memory

What `--keepdb` is for the default testrunner, `--reuse-db` is for pytest-django. I usually set this as the default for all test runs in `pytest.ini`.

```python
# pytest.ini
[pytest]
DJANGO_SETTINGS_MODULE=config.settings.testing
addopts = --reuse-db
```

To not re-use the database, pytest-django's argument is `--create-db`. So Harry's

```python
if 'keepdb' in sys.argv:
```

becomes

```python
if not 'create-db' in sys.argv:
```

in my case. To use the RAMDisk:

```python
# config/settings/testing.py

[...]

import sys
if not 'create-db' in sys.argv:
    # and this allows you to use --reuse-db to skip re-creating the db,
    # even faster!
    DATABASES['default']['TEST']['NAME'] = '/Volumes/RAMDisk/myfunnyproject.test.db.sqlite3'
```

## When there's no RAMDisk

If there is no RAMDisk, for example after a reboot, then the test run fails as soon as it hits the database. Obviously.

```python
>       conn = Database.connect(**conn_params)
E       django.db.utils.OperationalError: unable to open database file
```

I just throw another if statement in there to check for the existence of the RAMDisk.

```python
if os.path.isdir('/Volumes/RAMDisk') and not 'create-db' in sys.argv:
```

## Summary
You can check a full test configuration here:

[https://github.com/FlowFX/unkenmathe.de/blob/master/src/config/settings/testing.py](https://github.com/FlowFX/unkenmathe.de/blob/master/src/config/settings/testing.py)