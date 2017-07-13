<!--
.. title: Use Django in-memory file storage with pytest
.. slug: use-django-in-memory-file-storage-with-pytest
.. date: 2017-07-13 15:55:12 UTC-05:00
.. tags: django, in-memory, storage, pytest, fixture
.. category: 
.. link: 
.. description: 
.. type: text
-->

In my current project, I create PDF files from Jinja2/LaTeX templates. In each test run, several PDFs are created and saved to disk. How do you test this without filling up the hard drive?

I use an in-memory data storage. For Django there is a package that makes it really easy: [dj-inmemorystorage](https://github.com/waveaccounting/dj-inmemorystorage).

> A non-persistent in-memory data storage backend for Django.

Using [pytest fixtures](http://doc.pytest.org/en/latest/fixture.html):

    # tests/conftest.py
    import pytest
    import inmemorystorage
    
    from django.conf import settings
    
    @pytest.fixture
    def in_memory():
        settings.DEFAULT_FILE_STORAGE = 'inmemorystorage.InMemoryStorage'

That's it. When using this <code>in_memory</code> fixture in a test function, the files will never be written on disk.