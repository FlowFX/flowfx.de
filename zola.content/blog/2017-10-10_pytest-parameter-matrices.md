---
title: "pytest parameter matrices"
slug: pytest-parameter-matrices
date: 2017-10-10
taxonomies:
  tags: ["pytest", " django", " parametrization", " testing"]
  categories: 
---


A few months ago I explained how I efficiently [test Django forms with pytest parameterization](link://slug/testing-django-forms-with-pytest-parameterization). Last week, I learned a new trick from [Raphael Pierzina](https://github.com/hackebrot)'s post about [ids for fixtures and parametrize](https://hackebrot.github.io/pytest-tricks/param_id_func/), which is:

**You you can add multiple parametrization markers to a test function which then create a test parameter matrix.**

The list of test cases can thus be written much more clearly. Compare the example code from [my previous post](link://slug/testing-django-forms-with-pytest-parameterization):

```python  
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
```

to the same test using multiple parameterization markers:
 
```python
@pytest.mark.parametrize(
    'name, valid_name',
    [
        ('Hugo', True),
        ('', False),
        (None, False),
    ]
)
@pytest.mark.parametrize(
    'age, valid_age',
    [
        ('18', True),
        ('17', False),
        (None, False),
    ]
 )
def test_example_form(name, age, valid_name, valid_age):
    form = ExampleForm(data={
        'name': name,
        'age': age,
    })

    assert form.is_valid() is (valid_name and valid_age)
```

This tests all 9 possible combinations of the three test cases each for `name` and `age`. Maybe that's overkill, but on the other hand I can be sure that I touch all the relevant combinations.

Take note of the last line that checks that the form only validates when _both_ input parameters are valid.

The main advantage I see is legibility. For each form field, I  only have to understand the list of test parameters for exactly that field, and not any additional combinations with other fields.

I'm loving it!
