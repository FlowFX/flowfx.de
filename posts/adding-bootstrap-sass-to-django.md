<!-- 
.. title: Adding Bootstrap-SASS to Django
.. slug: adding-bootstrap-sass-to-django
.. date: 2017-03-22 18:57:40 UTC-06:00
.. tags: django, sass, draft
.. category: 
.. link: 
.. description: 
.. type: text
-->
https://django-compressor.readthedocs.io/en/latest/quickstart/#installation

```bash
(venv)$ pip install csscompressor django-compressor django-libsass
```

```python
INSTALLED_APPS = [
    ...
    'compressor',
]
```

```python
# Static files (CSS, JavaScript, Images)
STATICFILES_FINDERS = [
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
    'compressor.finders.CompressorFinder',
]
```


https://github.com/torchbox/django-libsass

```python
COMPRESS_PRECOMPILERS = (
    ('text/x-scss', 'django_libsass.SassCompiler'),
)
```


in base.thml


```html
{% load static %}
{% load compress %}

<!DOCTYPE html>
<html lang="es">
<head>
    ...
    
    {% compress css %}
        <link rel="stylesheet" type="text/x-scss" href="{% static "css/style.scss" %}" />
    {% endcompress %}
    
</head>
<body>
    ...
```