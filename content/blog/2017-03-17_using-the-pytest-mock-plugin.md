---
title: "Using the pytest-mock plugin"
slug: using-the-pytest-mock-plugin
date: 2017-03-17
taxonomies:
  tags: ["pytest", " mock", " plugin"]
  categories: 
---


After hearing about it [from Brian Okken](https://twitter.com/brianokken/status/842551389968461826), I today tried out the [pytest-mock plugin](https://pypi.python.org/pypi/pytest-mock). It is surprisingly simple to use and useful, too.

The other day I wrote about [mocks in Django views](/blog/mocking-database-calls-when-testing-django-views). The example test uses the <code>with</code> statement for patching the object.

    from mock import patch
    
    def test_detail_view(client):
        """Test the detail view for a Potato object with the Django test client."""
        potato = PotatoFactory.build()
        
        with patch.object(PotatoDetailView, 'get_object', return_value=potato):
            
            url = reverse('detail', kwargs={'pk': 1234})  # pk can be anything
            
            ...             

This works fine when only one patch is applied, but probably gets tedious quickly with more than one.
  
*Enter*: the pytest-mock plugin and its <code>mocker</code> fixture. Using this fixture, the test looks much cleaner.


```python
def test_detail_view_with_mocker(client, mocker):
    """Same test as above, but using the mocker fixture from pytest-mock."""
    potato = PotatoFactory.build()
    
    # This is new
    mocker.patch.object(PotatoDetailView, 'get_object', return_value=potato)
    
    url = reverse('detail', kwargs={'pk': 1234})
    
    [...]
```

pytest awesomeness!
