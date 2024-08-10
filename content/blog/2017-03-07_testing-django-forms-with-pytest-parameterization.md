---
title: "Testing Django forms with pytest parameterization"
slug: testing-django-forms-with-pytest-parameterization
date: 2017-03-07
taxonomies:
tags: ["python", "pytest", "django", "forms", "testing"]
categories: ["tech"]
---


Working on a largish Django project, I have to test a lot of web forms. My basic approach is to put data into the form and check if it validates. I started out using separate tests for valid and invalid input data, also thinking about for loops to handle different data sets. But you don't want to do that.

Pytest's [Parametrizing](http://doc.pytest.org/en/latest/parametrize.html) offers a really neat and concise solution to this problem. Consider this simple example:

    from django import forms
    
    import pytest
    
    
    class ExampleForm(forms.Form):
        name = forms.CharField(required=True)
        age = forms.IntegerField(min_value=18)
    
    
    @pytest.mark.parametrize(
        'name, age, validity',
        [('Hugo', 18, True),
         ('Egon', 17, False),
         ('Balder', None, False),
         ('', 18, False),
         (None, 18, False),
         ])
    def test_example_form(name, age, validity):
        form = ExampleForm(data={
            'name': name,
            'age': age,
        })
    
        assert form.is_valid() is validity

Here, three values are parameterized: the input for the two form fields and, given this data, whether or not the form should validate or not.

When working in a TDD-style, I start with one test case, code the  form logic, then add the next test case by adding just one line of parameters. And repeat.

<small>If you think there is a better way to test Django forms, please drop me a line [on the Twitter](https://www.twitter.com/flowfx_)!</small>

### Update 10/10/2017: [pytest parameter matrices](/blog/pytest-parameter-matrices)
