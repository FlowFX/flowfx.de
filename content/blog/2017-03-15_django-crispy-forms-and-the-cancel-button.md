---
title: "django-crispy-forms and the 'cancel' button"
slug: django-crispy-forms-and-the-cancel-button
date: 2017-03-15
taxonomies:
  tags: ["django", " form", " crispy-forms"]
  categories: 
---


I use [crispy-forms](http://django-crispy-forms.readthedocs.io/en/latest/) to render my Django forms. With crispy-forms there is almost no need to write any HTML. The template for form views can look like this:

	{% extends 'base.html' %}
	{% load crispy_forms_tags %}
	
	{% block content %}
	
	{% crispy form %}
	
	{% endblock content %}

By itself, this does not render a submit button. It has to be added to the form definition (cf. the [crispy-forms documentation](http://django-crispy-forms.readthedocs.io/en/latest/crispy_tag_forms.html#fundamentals) like this:

    from potatoes.models import Potato
    
    from crispy_forms.helper import FormHelper
    from crispy_forms.layout import Submit
    
    from django import forms
    
    
    class PotatoForm(forms.ModelForm):
        """ModelForm for the Potato model."""
    
        class Meta:  # noqa
            model = Potato
            fields = (
                'weight',
                'variety',
            )
    
        def __init__(self, *args, **kwargs):
            """Initiate form with Crispy Form's FormHelper."""
            super(PotatoForm, self).__init__(*args, **kwargs)
            self.helper = FormHelper()
            
            # Add 'Submit' button
            self.helper.add_input(Submit('submit', 'Submit'))

A view that uses this form is [my example project](https://github.com/FlowFX/sturdy-potato/)'s <code>PotatoCreateView</code>:

    class PotatoCreateView(CreateView):
        """Create view for the Potato model."""
    
        model = Potato
        form_class = PotatoForm
        template_name = 'potatoes/potato_form.html'

A submit button is nice, but I also want a cancel button. I add it to the crispy-forms <code>helper</code>, but that just shows a button that does the same as the submit button.

```python
# Add 'Submit' button
self.helper.add_input(Submit('submit', 'Submit'))
self.helper.add_input(Submit('cancel', 'Cancel', css_class='btn-danger',)
```

I need to overwrite the view's <code>post</code> method to do what I want, when the cancel button is clicked. For this, I use a model mixin, because why not.

	class FormActionMixin(object):
	
	    def post(self, request, *args, **kwargs):
	        """Add 'Cancel' button redirect."""
	        if "cancel" in request.POST:
            	url = reverse('index')     # or e.g. reverse(self.get_success_url())
            	return HttpResponseRedirect(url)
	        else:
            	return super(FormActionMixin, self).post(request, *args, **kwargs)
            	
    
    class PotatoCreateView(FormActionMixin, CreateView):
        """Create view for the Potato model."""
    
        ...

When the cancel button is clicked, the resulting <code>POST</code> request includes the <code>name</code> attribute of the button. Overwriting the <code>post</code> method for this case let's me redirect the user to whatever page I want.

*(note to self: research the Django way of redirecting to the previous page.)*

Now I have a submit and a cancel button. But on my CreateView it complains about required form fields.

![Screenshot](/images/screenshot-cancel-button-validates-form.png)

This has to do with HTML, and I found the solution [on Coderwall](https://coderwall.com/p/itb2hq/cancel-button-on-a-form-with-required-fields): the HTML attribute <code>formnovalidate</code>.

```python
self.helper.add_input(Submit('submit', 'Submit'))
self.helper.add_input(Submit(
    'cancel',
    'Cancel',
    css_class='btn-danger',
    formnovalidate='formnovalidate',
    )
)
```

That's it.

*(note to self: I need a test for this.)*