---
title: "Mocking database calls in Django view tests"
slug: mocking-database-calls-when-testing-django-views
date: 2017-03-10
tags: ["django", "mock", "pytest", "unit test", "testing"]
categories: ["tech"]
---


It took me a long time to understand the first thing about mocking in unit tests. The next few posts are intended to be a future reference to myself. Maybe you find them useful, or better, you can tell me how to do this better.

I created a simple Django project to document my solutions in working code: [https://github.com/FlowFX/sturdy-potato](https://github.com/FlowFX/sturdy-potato). For the purpose of these posts I will use the models, views and tests from this project. All views are [class-based views](https://docs.djangoproject.com/en/1.10/ref/class-based-views/).

Why mocking? Because I want fast tests. Database calls are especially slow, and for many tests, it is not necessary to actually write to or load from the database. So I want to avoid these.

## A simple view test
The <code>Potato</code> model has two attributes: <code>weight</code> and variety.

    from django.db import models
    from django.core.validators import MinValueValidator
    
    class Potato(models.Model):
        """The Potato model."""
    
        slug = models.SlugField(unique=True)
        weight = models.IntegerField(validators=[MinValueValidator(1)])
        variety = models.CharField(max_length=255)

The URL for the detail page:

    from django.conf.urls import url
    from potatoes import views
    
    urlpatterns = [
        [...]
        url(r'^potatoes/(?P<pk>[0-9]+)/$', views.PotatoDetailView.as_view(), name='detail'),
    ]

The view subclasses the [DetailView](http://ccbv.co.uk/projects/Django/1.10/django.views.generic.detail/DetailView/):

    from potatoes.models import Potato
    
    from django.views.generic import DetailView
    
    class PotatoDetailView(DetailView):
        """Detail view for the Potato object."""
        
        model = Potato


An simple way of testing this view is using the [Django test client](https://docs.djangoproject.com/en/1.10/topics/testing/tools/#the-test-client).

When using [pytest](http://doc.pytest.org/en/latest/), the test client is made available as a fixture by the [pytest-django](https://pytest-django.readthedocs.io/en/latest/) plugin. Because I don't use Django/unittest's <code>TestCase</code>, I need to make the test database available with the <code>@pytest.mark.django_db</code> decorator.

    from django.urls import reverse
    
    from potatoes.factories import PotatoFactory
    
    import pytest
    
    
    @pytest.mark.django_db
    def test_detail_view(client):
        """Test the detail view for a Potato object with the Django test client."""
    
        # (1) GIVEN a Potato object in the database
        potato = PotatoFactory.create()  # saves to database
    
        # (2) WHEN calling the DetailView for this object
        url = reverse('detail', kwargs={'pk': potato.id})
        response = client.get(url)
    
        content = response.content.decode()
        # (3) THEN it shows the potato's ID and it's type
        assert response.status_code == 200
        assert str(potato.weight) in content
        assert potato.variety in content

What's happening here?
  
1. Using [Factory Boy](https://factoryboy.readthedocs.io/en/latest/index.html)'s [DjangoModelFactory](https://factoryboy.readthedocs.io/en/latest/orms.html#django), a test <code>Potato</code> is created and written to the database.
2. The test client does a <code>GET</code> request to the URL of the details page of this Potato. This reads from the database.
3. It is checked whether the Potato's attributes are displayed on the page.

This test hits the database twice, although I only want to test whether my view (and kind of my template) works or not. I'm pretty sure the Django ORM works fine.

## View test with mock
In the test above, the object is only saved to the database so that the DetailView can read it from there. The method that reads from the database is the <code>PotatoDetailView</code>'s <code>get_object</code> method.

In order to avoid the database request, I can use a so-called monkey patch that provides a return value for the method, without hitting the database.


    from mock import patch
    
    def test_detail_view(client):
        """Test the detail view for a Potato object with the Django test client."""
    
        # (1) GIVEN a Potato object
        potato = PotatoFactory.build()  # not saved to the database

        # (2) monkey-patching    
        with patch.object(PotatoDetailView, 'get_object', return_value=potato):
        
            # (3) WHEN calling the DetailView for this object
            url = reverse('detail', kwargs={'pk': 1234})  # pk can be anything
            response = client.get(url)
            content = response.content.decode()
            
            # THEN it shows the potato's ID and it's type
            assert response.status_code == 200
            assert str(potato.weight) in content
            assert potato.variety in content

This is the same test with just a few changes.

1. The Potato instance is **not** saved to the database. (Check Factory Boy's <code>build()</code> vs. <code>create()</code> methods.)
2. This is the fun part. The patch <code>patch.object(PotatoDetailView, 'get_object', return_value=potato)</code>
takes the <code>PotatoDetailView</code> and, first of all, disables the <code>get_object</code> method. Second, it replaces the method by something that _always_ returns the <code>potato</code> instance. Always.
3. No matter what primary key we call the detail view with, it will always receive the test <code>potato</code> to work with. Which is really all we need to assert stuff.

There is no database call, no need for the django_db mark, just more speed.

For a [ListView](http://ccbv.co.uk/projects/Django/1.10/django.views.generic.list/ListView/), the method that has to be replaced by the patch is <code>get_queryset</code>. Check out [<code>test_list_view</code>](https://github.com/FlowFX/sturdy-potato/blob/master/potatoes/tests/test_models_with_mocks.py#L32) in the example project.
